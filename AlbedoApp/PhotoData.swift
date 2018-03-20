//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var rawPhotos: [CMSampleBuffer] = [] // the two raw photos that are taken will be appended to this array
    static var screenWidth: Int = 0
    static var screenHeight: Int = 0

    static func calculate() {
        if PhotoData.rawPhotos.count < 2 { // error check: this function only works if there are two sample buffers
            print("Error - there must be at least two photos to calculate.")
            return
        }
        
        guard let pixelBufferDown = CMSampleBufferGetImageBuffer(PhotoData.rawPhotos[0]) else {
            print("rawSampleBuffer does not contain a CVPixelBuffer")
            return
        }
        let rgbDown: [UInt32] = PhotoData.sum(pixelBuffer: pixelBufferDown)
        
        guard let pixelBufferUp = CMSampleBufferGetImageBuffer(PhotoData.rawPhotos[1]) else {
            print("rawSampleBuffer does not contain a CVPixelBuffer")
            return
        }
        let rgbUp: [UInt32] = PhotoData.sum(pixelBuffer: pixelBufferUp)
        
        let albedoR = rgbDown[0] / rgbUp [0]
        let albedoG = rgbDown[1] / rgbUp [1]
        let albedoB = rgbDown[2] / rgbUp [2]
        
        let albedo = albedoR + albedoG + albedoB
        print("******* Albedo (does this number make any sense?! who knows: \(albedo)")
    }
    
    //static func sum(pixelBuffer: CVPixelBuffer) -> [UInt32] {
    static func sum(pixelBuffer: CVPixelBuffer) -> [UInt32] {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        //let int32Buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt32>.self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let bufferWidth = Int(CVPixelBufferGetWidth(pixelBuffer))
        let bufferHeight = Int(CVPixelBufferGetHeight(pixelBuffer))
        let baseAddress: UInt32 = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        //print("int32Buffer:\(type(of: int32Buffer))")
        print("bytesPerRow:\(bytesPerRow)")
        
        //let x = 0
        //let y = 0
        //let width = CVPixelBufferGetWidth(pixelBufferUp)
        //let height = CVPixelBufferGetHeight(pixelBufferUp)
        //let width = 30 //PhotoData.screenWidth
        //let height = 30//PhotoData.screenHeight
        //print("width:\(width)")
        //print("height:\(height)")
        
        var b: UInt32 = 0
        var g: UInt32 = 0
        var r: UInt32 = 0
        let kBytesPerPixel: Int = 4
        for row: Int in 0 ..< bufferHeight {
            var pixel = Int(baseAddress) + row * bytesPerRow
            for col in 0 ..< bufferWidth {
                b += pixel[0] // blue val
                g += pixel[1] // green val
                r += pixel[2] // red val
            }
            pixel += kBytesPerPixel
        }
      
        
        /*for h in 0 ..< height {
            for w in 0 ..< width {
                b += int32Buffer[(w * 4) + (h * int32PerRow)];
                g += int32Buffer[((w * 4) + (h * int32PerRow)) + 1];
                r += int32Buffer[((w * 4) + (h * int32PerRow)) + 2];
                //print("r:\(r) g:\(g) b\(b)")
            }
        }*/
        
        //let luma = int32Buffer[43 + (int32PerRow * 17)]
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        //print("luma for 43,17: \(luma)")
        
        let rgb: [UInt32] = [r, g, b]
        return rgb
    }
}
