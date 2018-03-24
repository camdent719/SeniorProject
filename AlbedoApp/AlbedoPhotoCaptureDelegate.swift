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
        PhotoData.rawPhotos.append(rawSampleBuffer!)
        //if PhotoData.rawPhotos.count == 2 {
            //print("*** There Are 2 Photos ***")
            //PhotoData.calculate()
            
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(rawSampleBuffer!) else {
            return
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let int32Buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt32>.self)
        let int32PerRow = CVPixelBufferGetBytesPerRow(pixelBuffer) // 8064
        
        //let width = CVPixelBufferGetWidth(pixelBuffer) // 2656
        //let height = CVPixelBufferGetHeight(pixelBuffer) // 755
        //let width = PhotoData.screenWidth
        //let height = PhotoData.screenHeight
        
        let height = 750
        let width = 1334
    
        //print("width:\(width)")
        //print("height:\(height)")
    
        var b: UInt64 = 0
        var g: UInt64 = 0
        var r: UInt64 = 0
        for h in 0 ..< height {
            for w in 0 ..< width {
                b += UInt64(int32Buffer[(w * 4) + (h * int32PerRow)]);
                g += UInt64(int32Buffer[((w * 4) + (h * int32PerRow)) + 1]);
                r += UInt64(int32Buffer[((w * 4) + (h * int32PerRow)) + 2]);
                //print("\(r),\(g),\(b)")
            }
        }
        /*
        let widthMax = width
        let heightMax = height
        for indexX in 0..<widthMax {
            for indexY in 0..<heightMax {
                let offSet = indexY * bytesPerRow + indexX * bytesPerPixel
                r += UInt64(int32Buffer[pixelInfo + offSet])
                g += UInt64(int32Buffer[pixelInfo + 1 + offSet])
                b += UInt64(int32Buffer[pixelInfo + 2 + offSet])
            }
        }*/
    
        if PhotoData.photoDownRGB.isEmpty { // if the first photo (down) hasn't been taken, then this is the down photo
            PhotoData.photoDownRGB = [r, g, b]
        } else { // if the first photo hasn't been taken, then this is the up photo
            PhotoData.photoUpRGB = [r, g, b]
            PhotoData.calculateAlbedo()
        }
        //print("PhotoDownRGB: \(PhotoData.photoDownRGB)")
        //print("PhotoUpRGB:   \(PhotoData.photoUpRGB)")
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
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
