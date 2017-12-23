//
//  RawImageCapture.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/21/17.
//

import AVFoundation

class RawImageCapture: AVCaptureSession {

    var capturePhotoOutput:AVCaptureOutput = AVCapturePhotoOutput() // create photo output capture obj
    
    override init() {
        super.init()
    }
    
    
    
    // returns an AVCaptureDevice object with the selected camera
    func defaultDevice() -> AVCaptureDevice {
        if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera,
                                                      mediaType: AVMediaTypeVideo,
                                                      position: .back) {
            return device // use dual camera on supported devices
        } else if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                                             mediaType: AVMediaTypeVideo,
                                                             position: .back) {
            return device // use default back facing camera otherwise
        } else {
            fatalError("All supported devices are expected to have at least one of the queried capture devices.")
        }
    }
    
    // configure the capture sessions
    func configureCaptureSession(_ completionHandler: ((_ success: Bool) -> Void)) {
        var success = false
        defer { completionHandler(success) } // Ensure all exit paths call completion handler.
        
        // Get video input for the default camera.
        let videoCaptureDevice = defaultDevice()
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Unable to obtain video input for default camera.")
            return
        }
        
        // Create and configure the photo output.
        let capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        capturePhotoOutput.isLivePhotoCaptureEnabled = capturePhotoOutput.isLivePhotoCaptureSupported
        
        // Make sure inputs and output can be added to session.
//        guard self.captureSession.canAddInput(videoInput) else { return }
//        guard self.captureSession.canAddOutput(capturePhotoOutput) else { return }
//        
//        // Configure the session.
//        self.captureSession.beginConfiguration()
//        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
//        self.captureSession.addInput(videoInput)
//        self.captureSession.addOutput(capturePhotoOutput)
//        self.captureSession.commitConfiguration()
//        
//        self.capturePhotoOutput = capturePhotoOutput
        guard canAddInput(videoInput) else { return }
        guard canAddOutput(capturePhotoOutput) else { return }
        
        // Configure the session.
        beginConfiguration()
        sessionPreset = AVCaptureSessionPresetPhoto
        addInput(videoInput)
        addOutput(capturePhotoOutput)
        commitConfiguration()
        
        self.capturePhotoOutput = capturePhotoOutput
        
        success = true
    }
}
