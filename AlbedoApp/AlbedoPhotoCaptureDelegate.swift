//
//  AlbedoPhotoCaptureDelegate.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/1/18.
//
//  ------ Adapted from: -----
//
//  Apple's Sample Camera App - AVCamManual
//  https://developer.apple.com/library/content/samplecode/AVCamManual/Introduction/Intro.html
//

/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Photo capture delegate.
 */

import AVFoundation

protocol AlbedoPhotoCaptureDelegateType: class {}

class AlbedoPhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate, AlbedoPhotoCaptureDelegateType {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    var willCapturePhotoAnimation: ()->Void
    var completed: (AlbedoPhotoCaptureDelegate)->Void
    
    var jpegPhotoData: Data? // holds JPEG, which we don't need
    var dngPhotoData: Data?
    
    init(requestedPhotoSettings: AVCapturePhotoSettings, willCapturePhotoAnimation: @escaping ()->Void, completed: @escaping (AlbedoPhotoCaptureDelegate)->Void) {
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completed = completed
    }
    
    func didFinish() {
        self.completed(self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, willCapturePhotoForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.willCapturePhotoAnimation()
    }
    
    // this is the JPEG capture delegate method, which we don't need
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing photo: \(error)")
            return
        }
        
        self.jpegPhotoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing RAW photo: \(error)")
        }
        
        self.dngPhotoData = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            NSLog("Error capturing photo: \(error)")
            self.didFinish()
            return
        }
        
        if self.jpegPhotoData == nil && self.dngPhotoData == nil {
            NSLog("No photo data resource")
            self.didFinish()
            return
        }
    }
}
