//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation
import UIKit

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
        let rgbDown: [UInt32] = PhotoData.sumByConversion(pixelBuffer: pixelBufferDown)
        
        /*guard let pixelBufferUp = CMSampleBufferGetImageBuffer(PhotoData.rawPhotos[1]) else {
            print("rawSampleBuffer does not contain a CVPixelBuffer")
            return
        }
        let rgbUp: [UInt32] = PhotoData.sum(pixelBuffer: pixelBufferUp)
        
        let albedoR = rgbDown[0] / rgbUp[0]
        let albedoG = rgbDown[1] / rgbUp[1]
        let albedoB = rgbDown[2] / rgbUp[2]
        
        let albedo = albedoR + albedoG + albedoB
        print("******* Albedo (does this number make any sense?! who knows: \(albedo)")*/
    }
    
    // questions/8072208/how-to-turn-a-cvpixelbuffer-into-a-uiimage
    private static func sumByConversion(pixelBuffer: CVPixelBuffer) -> [UInt32] {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
       
        // create r, g, and b variables
        var b: UInt32 = 0
        var g: UInt32 = 0
        var r: UInt32 = 0
        
        var width: Int = CVPixelBufferGetWidth(pixelBuffer)
        var height: Int = CVPixelBufferGetHeight(pixelBuffer)
        var row: Int = CVPixelBufferGetBytesPerRow(pixelBuffer)
        var bytesPerPixel: Int = row / width
        var buffer = CVPixelBufferGetBaseAddress(pixelBuffer)
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(width), height: CGFloat(height)))
        var c = UIGraphicsGetCurrentContext()
        var data = c?.data()
        if data != nil {
            var maxY: Int = height
            for y in 0..<maxY {
                for x in 0..<width {
                    var offset: Int = bytesPerPixel * ((width * y) + x)
                    data[offset] = buffer[offset] // R
                    data[offset + 1] = buffer[offset + 1] // G
                    data[offset + 2] = buffer[offset + 2] // B
                    data[offset + 3] = buffer[offset + 3] // A
                }
            }
        }
        var img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
        
        //print("pixels array size: \(pixels?.count)")
        //print("pixels array type: \(type(of: pixels![0]))")
        //for p in pixels
        
        // create and return array
        let rgb: [UInt32] = [r, g, b]
        return rgb
    }
    
    //static func sum(pixelBuffer: CVPixelBuffer) -> [UInt32] {
    private static func sum(pixelBuffer: CVPixelBuffer) -> [UInt32] {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        //let int32Buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt32>.self)
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let bufferWidth = Int(CVPixelBufferGetWidth(pixelBuffer))
        let bufferHeight = Int(CVPixelBufferGetHeight(pixelBuffer))
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        //print("int32Buffer:\(type(of: int32Buffer))")
        print("bytesPerRow:\(bytesPerRow)")
        
        //let x = 0
        //let y = 0
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        //let width = 30 //PhotoData.screenWidth
        //let height = 30//PhotoData.screenHeight
        print("width:\(width)")
        print("height:\(height)")
        
        var b: UInt32 = 0
        var g: UInt32 = 0
        var r: UInt32 = 0
        // ---------- This is the first algorithm that apparently works in obj C but not Swift --------
        /*let kBytesPerPixel: Int = 4
        for row: Int in 0 ..< bufferHeight {
            var pixel = (baseAddress + row * bytesPerRow) as? [UInt32]//var pixel = Int(baseAddress) + row * bytesPerRow
            for col in 0 ..< bufferWidth {
                b += pixel[0] // blue val
                g += pixel[1] // green val
                r += pixel[2] // red val
            }
            pixel += kBytesPerPixel
        }*/
      
        // ---------- This is a second algorithm --------
        //for h in 0 ..< height {
        //    for w in 0 ..< width {
        /*for w in 0 ..< width {
            for h in 0 ..< height {
                b += int32Buffer[(w * 4) + (h * bytesPerRow)];
                g += int32Buffer[((w * 4) + (h * bytesPerRow)) + 1];
                r += int32Buffer[((w * 4) + (h * bytesPerRow)) + 2];
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
