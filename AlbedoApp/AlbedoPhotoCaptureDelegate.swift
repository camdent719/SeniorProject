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
    
    func capture(_ captureOutput: AVCapturePhotoOutput, willCapturePhotoForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.willCapturePhotoAnimation()
    }

    // this is the JPEG capture delegate method
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: 
        AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing photo: \(error)")
            return
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(photoSampleBuffer!) else {
            print("ERROR - could not create pixel buffer")
            return
        }
        
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        let cgimage = context.createCGImage(ciimage, from: ciimage.extent)
        
        let width = cgimage?.width
        let height = cgimage?.height
        let pixelData = cgimage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
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
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            NSLog("Error capturing RAW photo: \(error)")
        }
        
        self.dngPhotoData = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
       
        /*autoreleasepool {
            let imageBuffer = CMSampleBufferGetImageBuffer(rawSampleBuffer!)
            CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer!)
            let width: size_t = CVPixelBufferGetWidth(imageBuffer!)
            let height: size_t = CVPixelBufferGetHeight(imageBuffer!)
            let sourceBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(imageBuffer!), to: UnsafeMutableRawPointer)//UnsafeMutablePointer<UInt8>.self)
            CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let bufferSize = Int((bytesPerRow * height))
            let bgraData = malloc(bufferSize)
            memcpy(bgraData, sourceBuffer, bufferSize)
            let testArray = A
            let rgbData = malloc(width * height * 3)
            var rgbCount: Int = 0
            for i in 0..<height {
                var ii = 0
                while ii < width {
                    var current = Int(((i * height) + ii))
                    rgbData![rgbCount] = bgraData[current + 2]
                    rgbData[rgbCount + 1] = bgraData[current + 1]
                    rgbData[rgbCount + 2] = bgraData[current]
                    rgbCount += 3
                    ii += 4
                }
            }
            free(rgbData)*/
        
        //if PhotoData.rawPhotos.count == 2 {
            //print("*** There Are 2 Photos ***")
            //PhotoData.calculate()
        
        /* // ---------------------------------------------------------- DNG Photo Data Attempt ----------------------------------------------------------
        var i = 0
        self.dngPhotoData?.forEach { element in
            if i > 1000000 && i < 1000250 {//i % 10000 == 0 {
                print(element)
            }
            i += 1
        }
        print("\nCount: \(i)")
        print("Max: \(String(describing: self.dngPhotoData!.max()))")
        print("First: \(self.dngPhotoData!.first!)")
        // -------------------------------------------------------------------------------------------------------------------------------------------- */
        
        
        /*// most recent attempt
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(rawSampleBuffer!) else {
            return
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let int32Buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt32>.self)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer) // 8064
        
        let width: Int = CVPixelBufferGetWidth(pixelBuffer) // 2656
        let height: Int = CVPixelBufferGetHeight(pixelBuffer) // 755
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.noneSkipFirst.rawValue  //none.rawValue//CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        
        
        guard let context: CGContext = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 5, bytesPerRow: bytesPerRow, space: colorspace, bitmapInfo: bitmapInfo)!
        else {
            print("Could not create context");
            return
        }*/
        
        //let width = PhotoData.screenWidth
        //let height = PhotoData.screenHeight
        
        //let height = 750
        //let width = 1334
    
        //print("width:\(width)")
        //print("height:\(height)")
    
        //var b: UInt64 = 0
        //var g: UInt64 = 0
        //var r: UInt64 = 0
        /*for h in 0 ..< height {
            for w in 0 ..< width {
                b += UInt64(int32Buffer[(w * 4) + (h * int32PerRow)]);
                g += UInt64(int32Buffer[((w * 4) + (h * int32PerRow)) + 1]);
                r += UInt64(int32Buffer[((w * 4) + (h * int32PerRow)) + 2]);
                //print("\(r),\(g),\(b)")
            }
        }*/
        
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
    
        /*if PhotoData.photoDownRGB.isEmpty { // if the first photo (down) hasn't been taken, then this is the down photo
            PhotoData.photoDownRGB = [r, g, b]
        } else { // if the first photo hasn't been taken, then this is the up photo
            PhotoData.photoUpRGB = [r, g, b]
            PhotoData.calculateAlbedo()
        }*/
        //print("PhotoDownRGB: \(PhotoData.photoDownRGB)")
        //print("PhotoUpRGB:   \(PhotoData.photoUpRGB)")
        
        //CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
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
