//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var rawPhotos: [CMSampleBuffer] = [] // the two raw photos that are taken will be appended to this array
    static var photoDownRGB: [UInt64] = []
    static var photoUpRGB: [UInt64] = []
    static var screenWidth: Int = 0
    static var screenHeight: Int = 0
    static var albedo: String = "" // saves a string representation of the albedo measurement

    static func calculateAlbedo() {
        if PhotoData.photoDownRGB.isEmpty && PhotoData.photoUpRGB.isEmpty {//PhotoData.rawPhotos.count < 2 { // error check: this function only works if there are two sample buffers
            print("Error - there must be at least two photos to calculate.")
            return
        }
        
        /*guard let pixelBufferDown: CVPixelBuffer = CMSampleBufferGetImageBuffer(PhotoData.rawPhotos[0]) else {
            print("rawSampleBuffer does not contain a CVPixelBuffer")
            return
        }
        let rgbDown: [UInt32] = PhotoData.sumByConversion(pixelBuffer: pixelBufferDown)*/
        //let arr = Pixels.getPixelData(PhotoData.rawPhotos[0])
        
        /*guard let pixelBufferUp: CVPixelBuffer = CMSampleBufferGetImageBuffer(PhotoData.rawPhotos[1]) else {
            print("rawSampleBuffer does not contain a CVPixelBuffer")
            return
        }
        let rgbUp: [UInt32] = PhotoData.sum(pixelBuffer: pixelBufferUp)*/
        
        let albedoR: Double = Double(photoDownRGB[0]) / Double(photoUpRGB[0])
        let albedoG: Double = Double(photoDownRGB[1]) / Double(photoUpRGB[1])
        let albedoB: Double = Double(photoDownRGB[2]) / Double(photoUpRGB[2])
        let albedo: Double = albedoR + albedoG + albedoB
        
        // format albedo to 2 decimal places
        PhotoData.albedo = String(format: "%.2f", arguments: [albedo])
        
        print("******* Albedo (does this number make any sense?! who knows: \(PhotoData.albedo)")
    }
    
    // questions/8072208/how-to-turn-a-cvpixelbuffer-into-a-uiimage
    /*private static func sumByConversion(pixelBuffer: CVPixelBuffer) -> [UInt32] {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
       
        // create r, g, and b variables
        var b: UInt32 = 0
        var g: UInt32 = 0
        var r: UInt32 = 0
        
        let width: Int = CVPixelBufferGetWidth(pixelBuffer)
        let height: Int = CVPixelBufferGetHeight(pixelBuffer)
        let row: Int = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let bytesPerPixel: Int = row / width
        let buffer = CVPixelBufferGetBaseAddress(pixelBuffer)
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(width), height: CGFloat(height)))
        let c: CGContext = UIGraphicsGetCurrentContext()!
        
        let pointer: UnsafeMutableRawPointer = c.data! // objc: unsigned char* data = CGBitmapContextGetData(c);
        //let i32 = pointer.load(fromByteOffset: 4, as: UInt32.self)
        let i32bufferPointer = UnsafeBufferPointer(start: buffer?.assumingMemoryBound(to: UInt32.self), count: 1) // pointer
        
        
        if i32bufferPointer != nil {
            let maxY: Int = height
            for y in 0..<maxY {
                for x in 0..<width {
                    let offset: Int = bytesPerPixel * ((width * y) + x)
                    r += i32bufferPointer[offset] // R
                    g += i32bufferPointer[offset + 1] // G
                    b += i32bufferPointer[offset + 2] // B
                    //i16bufferPointer[offset + 3] // A
                }
            }
        }
        print("loop done. r:\(r) g:\(g) b\(b)")
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
        
        //print("pixels array size: \(pixels?.count)")
        //print("pixels array type: \(type(of: pixels![0]))")
        //for p in pixels
        
        // create and return array
        let rgb: [UInt32] = [r, g, b]
        return rgb
    }*/
    
    /*//static func sum(pixelBuffer: CVPixelBuffer) -> [UInt32] {
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
    }*/
}
