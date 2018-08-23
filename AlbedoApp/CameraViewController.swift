//
//  CameraViewController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/22/17.
//
//  ----- Adapted from: -----
//
//  Apple's Photo Capture Guide
//  https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/PhotoCaptureGuide/index.html
//
//  Apple's Sample Camera App - AVCamManual
//  https://developer.apple.com/library/content/samplecode/AVCamManual/Introduction/Intro.html
//
//  Apple's CoreMotion Demo App - MotionGraphs
//  https://developer.apple.com/library/content/samplecode/MotionGraphs/Introduction/Intro.html
//

import UIKit
import AVFoundation
import CoreMotion

class CameraViewController: UIViewController {
    
    // This flag represents whether or not the app is in proof of concept mode, which takes a JPEG instead of RAW.
    // Currently, there is not a way to analyze the RAW bayer filter pixel data to get RGB, so if this flag is set
    // to true, the app will run by taking a JPEG and doing the RGB calculation. The resulting albedo value will not
    // be accurate, but this is merely to demonstrate the app's capabilities.
    private let JPEG_MODE = true
    
    // Camera and UI properties
    @IBOutlet var capturePreviewViews: [CameraPreviewView]!
    private var sessionQueue: DispatchQueue!
    private var isSessionRunning: Bool = false
    private var setupResult: CameraSetupResult = .success
    private var videoDeviceDiscoverySession: AVCaptureDevice.DiscoverySession?
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var rearCamera: AVCaptureDevice?
    private var rearCameraInput: AVCaptureDeviceInput?
    private var inProgressPhotoCaptureDelegates: [Int64: AlbedoPhotoCaptureDelegateType] = [:]
    
    private let exposureDuration: Int32 = 500 // expsoure duration will be (1 / exposureDuration) seconds
    private let iso: Float = 50.0
    
    // MotionGraphContainer properties
    let motionManager = CMMotionManager() // motion manager object
    let levelingThreshold = 1.5 // within how many degrees the device must be in order to count as level
    let updateInterval = 0.02 // measured in seconds
    
    var circularLevel: CircularLevel! // create a circular level object
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: UIViewController overrides
    override func viewDidLoad() {
        // add the circular level to the view
        circularLevel = CircularLevel(frame: UIScreen.main.bounds) // create a new Circular Level object
        self.view.addSubview(circularLevel) // add it to the view
        
        // camera setup
        self.captureSession = AVCaptureSession()
        let deviceTypes: [AVCaptureDevice.DeviceType] = [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInDualCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera]
        self.videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: AVMediaType.video, position: .unspecified)
        
        // Setup the preview view.
        self.capturePreviewViews.last?.session = self.captureSession
        self.capturePreviewViews.last?.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // Communicate with the session and other session objects on this queue.
        self.sessionQueue = DispatchQueue(label: "session queue", attributes: [])
        self.setupResult = .success
        
        // Check video authorization status. Video access is required and audio access is optional.
        // If audio access is denied, audio is not recorded during movie recording.
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            break // The user has previously granted access to the camera.
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session running until the access request has completed.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            self.sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video) {granted in
                if !granted {
                    self.setupResult = .cameraNotAuthorized
                }
                self.sessionQueue.resume()
            }
        default:
            // The user has previously denied access.
            self.setupResult = .cameraNotAuthorized
        }
        
        self.sessionQueue.async {
            self.configureSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startMotionUpdates() // start device motion updates
        
        // set up camera
        self.sessionQueue.async {
            switch self.setupResult {
            case .success: // Only setup observers and start the session running if setup succeeded.
                self.captureSession?.startRunning()
                self.isSessionRunning = (self.captureSession?.isRunning)!
            case .cameraNotAuthorized: // if camera not authorized, alert user
                DispatchQueue.main.async {
                    let message = NSLocalizedString("Albedo App requires access to the camera in order to take images needed to calculate albedo.", comment: "Needs camera permission")
                    let alertController = UIAlertController(title: "AVCamManual", message: message, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    // Provide quick access to Settings.nil
                    let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default) {action in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                        } else {
                            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                        }
                    }
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .sessionConfigurationFailed: // if session config failed, alert user
                DispatchQueue.main.async {
                    let message = NSLocalizedString("Unable to capture media", comment: "Alert if capture session configuration error")
                    let alertController = UIAlertController(title: "Albedo App", message: message, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // stop capture session and motion updates when view disappears
    override func viewDidDisappear(_ animated: Bool) {
        stopMotionUpdates()
        self.sessionQueue.async {
            if self.setupResult == .success {
                self.captureSession?.stopRunning()
                self.captureSession = nil
            }
        }
        super.viewDidDisappear(animated)
    }
    
    // function that is responsible for configuring all necessary objects for image capture
    func configureSession() {
        guard self.setupResult == .success else {
            return
        }
        
        self.captureSession?.beginConfiguration()
        self.captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        
        // Add video input - get the rear camera and create a video input object for the rear camera
        let videoDevice: AVCaptureDevice!
        videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for:AVMediaType.video, position: .unspecified)
        
        // set the exposure mode to ensure that the pictures are always captured with the same exposure
        do {
            try videoDevice.lockForConfiguration()
            if videoDevice.isExposureModeSupported(AVCaptureDevice.ExposureMode.locked) {
                let exposureDuration:CMTime = CMTimeMake(1, self.exposureDuration)
                videoDevice.setExposureModeCustom(duration: exposureDuration, iso: self.iso, completionHandler: nil)
            }
        } catch {
            print("Error - could not set exposure")
        }
        
        // create the video device input object
        let videoDeviceInput: AVCaptureDeviceInput
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device:videoDevice)
        } catch {
            NSLog("Could not create video device input: \(error)")
            self.setupResult = .sessionConfigurationFailed
            self.captureSession?.commitConfiguration()
            return
        }
        
        // if input can be added to the capture session, add it
        if (self.captureSession?.canAddInput(videoDeviceInput))! {
            self.captureSession?.addInput(videoDeviceInput)
            self.rearCameraInput = videoDeviceInput
            self.rearCamera = videoDevice
            
            DispatchQueue.main.async {
                let statusBarOrientation = UIApplication.shared.statusBarOrientation
                var initialVideoOrientation = AVCaptureVideoOrientation.portrait
                if statusBarOrientation != UIInterfaceOrientation.unknown {
                    initialVideoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue)!
                }
                
                let previewLayer = self.capturePreviewViews.last?.layer as! AVCaptureVideoPreviewLayer
                previewLayer.connection?.videoOrientation = initialVideoOrientation
            }
        } else {
            NSLog("Could not add video device input to the session")
            self.setupResult = .sessionConfigurationFailed
            self.captureSession?.commitConfiguration()
            return
        }
        
        // Add photo output to session
        let photoOutput = AVCapturePhotoOutput()
        if (self.captureSession?.canAddOutput(photoOutput))! {
            self.captureSession?.addOutput(photoOutput)
            self.photoOutput = photoOutput
            photoOutput.isHighResolutionCaptureEnabled = true
            
            self.inProgressPhotoCaptureDelegates = [:]
        } else {
            NSLog("Could not add photo output to the session")
            self.setupResult = .sessionConfigurationFailed
            self.captureSession?.commitConfiguration()
            return
        }
        
        self.captureSession?.commitConfiguration() // commit configuration
    }
    
    private func captureImage() {
        // create the photo settings object based on the mode
        var settings: AVCapturePhotoSettings
        if JPEG_MODE { // For non-RAW proof of concept: use kCVPixelFormatType_32BGRA
            let formatType = kCVPixelFormatType_32BGRA
            guard (photoOutput?.availablePhotoPixelFormatTypes.contains(OSType(truncating: NSNumber(value: formatType))))! else { print("ERROR - The kCVPixelFormatType_32BGRA format is not available"); return }
            settings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: formatType)])
        } else { // For RAW capture: use kCVPixelFormatType_14Bayer_RGGB
            let rawFormatType = kCVPixelFormatType_14Bayer_RGGB
            guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(OSType(truncating: NSNumber(value: rawFormatType))))! else { print("ERROR - The kCVPixelFormatType_14Bayer_RGGB format is not available"); return }
            settings = AVCapturePhotoSettings(rawPixelFormatType: rawFormatType)
        }
        
        self.sessionQueue.async {
            let photoCaptureDelegate = AlbedoPhotoCaptureDelegate(requestedPhotoSettings: settings, willCapturePhotoAnimation: {
                // Perform a shutter animation.
                DispatchQueue.main.async {
                    self.capturePreviewViews.last?.layer.opacity = 0.0
                    UIView.animate(withDuration: 0.25) {
                        self.capturePreviewViews.last?.layer.opacity = 1.0
                    }
                }
            }, completed: {photoCaptureDelegate in
                // When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
                self.sessionQueue.async {
                    self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = nil
                }
            })
            
            // capture the photo using the photo capture delegate
            self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = photoCaptureDelegate
            self.photoOutput?.capturePhoto(with: settings, delegate: photoCaptureDelegate)
        }
        
        stopMotionUpdates() // stop device motion updates
        
        // move to next view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            var nextViewController: UIViewController
            if !PhotoData.photoDownRGB.isEmpty && PhotoData.photoUpRGB.isEmpty { // if this was the first photo, then move to next view so the 2nd photo can be taken
                nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntermediateViewController"))!
            } else { // otherwise, both photos have been taken, so move to next appropriate view
                nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "OptionalDataViewController"))!
            }
            self.present(nextViewController, animated: true)
        })
    }
    
    // start updates for leveling data. Captures image when roll, pitch, and yaw meet the established
    // threshold set by the property levelingThreshold
    func startMotionUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("ERROR - dev motion not available");
            return
        }
        motionManager.deviceMotionUpdateInterval = self.updateInterval
        
        // this function runs every self.updateInterval seconds to constantly update motion data
        motionManager.startDeviceMotionUpdates(to: .main) { deviceMotion, error in
            guard let deviceMotion = deviceMotion else { return }

            self.circularLevel.getPoint(attitude: deviceMotion.attitude) // this updates the ball's position
            
            let roll = deviceMotion.attitude.roll * (180 / Double.pi) // get roll, convert from radians to degrees
            let pitch = deviceMotion.attitude.pitch * (180 / Double.pi) // get pitch, convert from radians to degrees
            //let yaw = deviceMotion.attitude.yaw * (180 / Double.pi) // get yaw, convert from radians to degrees
            let thresh = self.levelingThreshold
            
            // ensure that roll, pitch, and yaw are all within the threshold to take a picture
            if PhotoData.photoDownRGB.isEmpty { // no photos have been taken yet; this is the first photo
                if abs(roll) <= thresh && abs(pitch) <= thresh {
                    print("*** Device is level - capturing image - roll:\(roll) pitch:\(pitch)")
                    self.captureImage() // calls the capture image function when level
                }
            } else { // the down photo has been taken already, so now take the up photo
                if (180 - abs(roll)) <= thresh && abs(pitch) <= thresh {
                    print("*** Device is level - capturing image - roll:\(roll) pitch:\(pitch)")
                    self.captureImage() // calls the capture image function when level
                }
            }
        }
    }
    
    // stop the leveling data updates
    func stopMotionUpdates() {
        if !motionManager.isDeviceMotionActive { return }
        motionManager.stopDeviceMotionUpdates()
    }
}

private enum CameraSetupResult: Int {
    case success
    case cameraNotAuthorized
    case sessionConfigurationFailed
}
