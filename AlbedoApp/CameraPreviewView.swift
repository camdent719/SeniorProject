//
//  CameraPreviewView.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/2/18.
//
//  ------ Adapted from: -----
//
//  Apple's Sample Camera App - AVCamManual
//  https://developer.apple.com/library/content/samplecode/AVCamManual/Introduction/Intro.html
//

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Camera preview.
 */

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var session: AVCaptureSession? {
        get {
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            return previewLayer.session
        }
        
        set {
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            previewLayer.session = newValue
        }
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        get {
            return self.layer as! AVCaptureVideoPreviewLayer
        }
    }
}
