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

import AVFoundation
import UIKit

protocol AlbedoPhotoCaptureDelegateType: class {}

class AlbedoPhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate, AlbedoPhotoCaptureDelegateType {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    var willCapturePhotoAnimation: ()->Void
    var completed: (AlbedoPhotoCaptureDelegate)->Void
    
    var jpegPhotoData: Data?
    var dngPhotoData: Data?
    
    init(requestedPhotoSettings: AVCapturePhotoSettings, willCapturePhotoAnimation: @escaping ()->Void, completed: @escaping (AlbedoPhotoCaptureDelegate)->Void) {
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completed = completed
    }
    
    func didFinish() {
        self.completed(self)
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.willCapturePhotoAnimation()
    }

    // this is the JPEG capture delegate method
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: 
        AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing photo: \(error)")
            return
        }
        
        //self.jpegPhotoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        // get the pixel buffer for the image out of the sample buffer
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(photoSampleBuffer!) else {
            print("ERROR - could not create pixel buffer")
            return
        }
        
        // convert the pixel buffer to a CIImage, and then convert the CIImage to a CGImage
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        let cgimage = context.createCGImage(ciimage, from: ciimage.extent)
        
        // get necessary properties from the image
        let width = cgimage?.width
        let height = cgimage?.height
        let pixelData = cgimage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        // iterate through the data array of pixel data.
        // The pixel data for pixel (xCoord, yCoord) is obtained with the following line of code:
        //     let pixel: Int = ((width! * yCoord) + xCoord) * 4
        for w in 0 ..< width! {
            for h in 0 ..< height! {
                let pixel: Int = ((width! * h) + w) * 4
                r += CGFloat(data[pixel]) / CGFloat(255.0)
                g += CGFloat(data[pixel+1]) / CGFloat(255.0)
                b += CGFloat(data[pixel+2]) / CGFloat(255.0)
            }
        }
        
        if PhotoData.photoDownRGB.isEmpty { // if the first photo (down) hasn't been taken, then this is the down photo
            PhotoData.photoDownRGB = [r, g, b]
        } else { // if the first photo hasn't been taken, then this is the up photo
            PhotoData.photoUpRGB = [r, g, b]
            PhotoData.calculateAlbedo()
        }
    }
    
    // this is the RAW capture delegate method
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhoto rawSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing RAW photo: \(error)")
        }
        
        //self.dngPhotoData = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
       
        //
        // code to interpret RAW image data added here
        //
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
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
