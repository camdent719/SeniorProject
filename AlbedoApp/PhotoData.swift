//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var stationIndex: Int = 0 // "None" by default
    static var latitude: Double! = nil
    static var longitude: Double! = nil
    static var date: Date! = nil
    static var startTime: Date! = nil
    static var endTime: Date! = nil
    static var skyAnalysis: SkyAnalysis = SkyAnalysis.none
    static var snowState: SnowState = SnowState.none
    static var patchinessPercentage: Int = 0
    static var snowSurfaceIndex: Int = 0 // "Current" by default
    static var groundCover: GroundCover = GroundCover.none
    static var otherGroundCover: String = "" // non-empty if other ground cover applies
    static var snowSurfaceAge: SnowSurfaceAge = SnowSurfaceAge.none
    
    static var photoDownRGB: [CGFloat] = []
    static var photoUpRGB: [CGFloat] = []
    static var albedo: String = "" // saves a string representation of the albedo measurement
    
    static var snowDepth: Float = Float.nan
    static var snowWeight: Float = Float.nan
    static var snowTubeTareWeight = Float.nan
    static var snowTemp: Float = Float.nan
    static var debrisDescription: String = ""

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
        stationIndex = 0
        latitude = nil
        longitude = nil
        date = nil
        startTime = nil
        endTime = nil
        skyAnalysis = SkyAnalysis.none
        snowSurfaceIndex = 0
        snowState = SnowState.none
        patchinessPercentage = 0
        groundCover = GroundCover.none
        otherGroundCover = ""
        snowSurfaceAge = SnowSurfaceAge.none
        
        photoDownRGB.removeAll()
        photoUpRGB.removeAll()
        albedo = ""
        
        snowDepth = Float.nan
        snowWeight = Float.nan
        snowTubeTareWeight = Float.nan
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
    case other = "Other"
    // enum Other {
    //     case value(String)
    // }
}

/*enum GroundCover: String {
    case none = "None" // default value
    case grassLiving = "Grass - Living"
    case grassDead = "Grass - Dead"
    case wetSoil = "Wet Soil"
    case drySoil = "Dry Soil"
    case pavement = "Pavement"
    case woodenDeck = "Wooden Deck"
    // enum Other {
    //     case value(String)
    // }
}*/

/*enum GroundCover {
    // name will be filled with one of the following:
    // none = "None"
    // grassLiving = "Grass - Living"
    // grassDead = "Grass - Dead"
    // wetSoil = "Wet Soil"
    // drySoil = "Dry Soil"
    // pavement = "Pavement"
    // woodenDeck = "Wooden Deck"
    //
    // if a different ground cover applies, the name will be that
    case name(String) // default value
}*/

enum SnowSurfaceAge: String {
    case none = "None" // default value
    case current = "Currently Snowing"
    case snow1Day = "< 1 Day Old"
    case snow2Days = "1 Full Day Old"
    case snow3Days = "2 Full Days Old"
    case snow4Days = "3 Full Days Old"
    case snow5Days = "4 Full Days Old"
    case snow6Days = "5 Full Days Old"
    case snow1Week = "6 Full Days Old"
    case snow2Weeks = "1 Full Week Old"
    case snow3Weeks = "2 Full Weeks Old"
    case snow4Weeks = "3 Full Weeks Old"
    case snowAtLeast4Weeks = "≥ 4 Full Weeks Old"
}


