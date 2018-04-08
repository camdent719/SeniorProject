//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var skyAnalysis: SkyAnalysis = SkyAnalysis.none
    static var snowState: SnowState = SnowState.none
    static var patchinessPercentage: Int = 0
    static var groundCover: GroundCover = GroundCover.none
    static var snowSurfaceAge: SnowSurfaceAge = SnowSurfaceAge.none
    
    static var photoDownRGB: [UInt64] = []
    static var photoUpRGB: [UInt64] = []
    static var albedo: String = "" // saves a string representation of the albedo measurement
    
    static var snowDepth: Float = Float.nan
    static var snowWeight: Float = Float.nan
    static var snowTemp: Float = Float.nan
    static var debrisDescription: String = ""
    
    static var screenWidth: Int = 0
    static var screenHeight: Int = 0

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
    
    static func clearData() {
        skyAnalysis = SkyAnalysis.none
        snowState = SnowState.none
        patchinessPercentage = 0
        groundCover = GroundCover.none
        snowSurfaceAge = SnowSurfaceAge.none
        
        photoDownRGB.removeAll()
        photoUpRGB.removeAll()
        albedo = ""
        
        snowDepth = Float.nan
        snowWeight = Float.nan
        snowTemp = Float.nan
        debrisDescription = ""
    }
}

enum SkyAnalysis: String {
    case none = "None" // default value
    case allClear = "All clear"
    case clear = "Clear"
    case cloudy = "Partly cloudy"
    case overcast = "Overcast"
}

enum SnowState: String {
    case none = "None" // default value
    case snowCovered = "Snow-covered"
    case patchySnow = "Patchy Snow"
    case snowFreeDormant = "Snow-free/Dormant"
    case snowFreeGreen = "Snow-free/Green"
}

enum GroundCover: String {
    case none = "None" // default value
    case grassLiving = "Grass - Living"
    case grassDead = "Grass - Dead"
    case wetSoil = "Wet Soil"
    case drySoil = "Dry Soil"
    case pavement = "Pavement"
    case woodenDeck = "Wooden Deck"
}

enum SnowSurfaceAge: String {
    case none = "None" // default value
    case fresh = "Fresh Snow"
    case snow2Days = "Snow Within Past 2 Days"
    case snow3Days = "Snow Within Past 3 Days"
    case snow4Days = "Snow Within Past 4 Days"
    case snowOver4Days = "Snow Older Than 4 Days"
    case dontKnow = "Don't Know"
}


