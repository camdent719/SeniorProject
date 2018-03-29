//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var photoDownRGB: [UInt64] = []
    static var photoUpRGB: [UInt64] = []
    static var screenWidth: Int = 0
    static var screenHeight: Int = 0
    static var albedo: String = "" // saves a string representation of the albedo measurement

    static func calculateAlbedo() {
        if PhotoData.photoDownRGB.isEmpty && PhotoData.photoUpRGB.isEmpty { // error check: this function only works if there are two sample buffers
            print("Error - there must be at least two photos to calculate.")
            return
        }
        
        let albedoR: Double = Double(photoDownRGB[0]) / Double(photoUpRGB[0]) // calculate albedo for R
        let albedoG: Double = Double(photoDownRGB[1]) / Double(photoUpRGB[1]) // calculate albedo for G
        let albedoB: Double = Double(photoDownRGB[2]) / Double(photoUpRGB[2]) // calculate albedo for B
        let albedo: Double = albedoR + albedoG + albedoB
        
        // format albedo to 2 decimal places
        PhotoData.albedo = String(format: "%.2f", arguments: [albedo])
        
        print("******* Albedo Value: \(PhotoData.albedo)")
    }
}
