//
//  CameraController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/22/17.
//
//  Adapted from:
//
//  "Building a Full Screen Camera App Using AVFoundation" by Pranjal Satija, AppCoda.com
//  https://www.appcoda.com/avfoundation-swift-guide/
//
//  Apple's Photo Capture Guide
//  https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/PhotoCaptureGuide/index.html
//

import AVFoundation
import UIKit

//@objc protocol AVCapturePhotoOutputType {
//   @objc(availableRawPhotoPixelFormatTypes)
//    var __availableRawPhotoPixelFormatTypes: [NSNumber] {get}
//    printf("Num Available Raw Photo Types: \(__availableRawPhotoPixelFormatTypes.length)")
//}

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    
    var currentCameraPosition: CameraPosition?
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureFlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    var rawSampleBuffer: CMSampleBuffer?
    var rawPreviewPhotoSampleBuffer: CMSampleBuffer?
    
    var dngPhotoData: Data? // this is where the raw image data gets stored
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
            guard let cameras = (session?.devices.flatMap { $0 }), !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera             
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.currentCameraPosition = .rear
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            print("Entered configuredPhotoOutput")
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput) { captureSession.addOutput(self.photoOutput) }

            //captureSession.commitConfiguration()
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    // displays the camera view on the UI storyboard
    func displayPreview(on view: UIView) throws {
        //guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    // switches camera between front and rear
    /*func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
            }
                
            else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }*/
    
    // resposnible for capturing the image
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        //guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        /*// specifies that the image must be raw
        guard let availableRawFormat = self.photoOutput?.availableRawPhotoPixelFormatTypes.first else { print("*** There are literally no raw formats available"); return }
        let settings = AVCapturePhotoSettings(rawPixelFormatType: availableRawFormat.uint32Value)
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
        */
        
        /*// this is the only type supported in modern iPhones besides kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange and kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        let photoSettings =  try AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(NSNumber(value: rawFormatType)))! else { print("*** Raw Format Type Unavailable"); return }
        
        
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
        self.photoCaptureCompletionBlock = completion
        */
        
        //print("Here it is:")
        //print("-----------")
        //print(photoOutput?.__availableRawPhotoPixelFormatTypes)
        
        /*let rawFormatType = kCVPixelFormatType_32BGRA
        guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(NSNumber(value: rawFormatType)))! else {
            print("*** ERROR: No available raw pixel formats ***")
            return
        }*/
        
        let pixelFormatType = NSNumber(value: kCVPixelFormatType_32BGRA)
        guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(pixelFormatType))! else { print("ERROR: No available raw pixel formats"); return }
        
        let settings = AVCapturePhotoSettings(format: [
            kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType
            ])

        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        print("Capture Photo Occurred!")
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    public func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        /*if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = rawSampleBuffer, let data = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
            print("something happens here")
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
        print("did finish processing!!!!!!!!!!!")
        guard error == nil, let rawSampleBuffer = rawSampleBuffer else {
            print("Error capturing RAW photo:\(String(describing: error))")
            return
        }
        
        self.rawSampleBuffer = rawSampleBuffer
        self.rawPreviewPhotoSampleBuffer = previewPhotoSampleBuffer*/
        
        if let error = error {
            print("Error - RAW image could not be captured: \(error)")
        }
        self.dngPhotoData = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        /*
        // convert the NSData object to a CGImage so that the individual pixels can be analyzed
        //let myDataRef:CFData = self.dngPhotoData as! CFData
        //let imageSource:CGImageSource = CGImageSourceCreateWithData(myDataRef, nil)!
        //let rawCGImage:CGImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)!
        
        // convert the NSData object to a UIImage so that the individual pixels can be analyzed
        let rawUIImage:UIImage = UIImage(data:dngPhotoData!, scale:1.0)!
        
        // check to be sure the conversion worked before using
        if rawUIImage == .none {
            print("Error - image could not be converted")
        }
        calculate(image:rawUIImage)
         */
    }
    
    /*func calculate(image:UIImage) {
        var sumR:UInt8 = 0, sumG:UInt8 = 0, sumB:UInt8 = 0
        if let reader = ImagePixelReader(image: image) {
            // iterate over all pixels
            for x in 0 ..< Int(image.size.width){
                for y in 0 ..< Int(image.size.height){
                    let color = reader.colorAt(x: x, y: y)
                    sumR += color.r
                    sumG += color.g
                    sumB += color.b
                }
            }
        }
    }*/
}
