//
//  PhotoData.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/5/18.
//

import AVFoundation

struct PhotoData {
    static var userID: Int = 0
    static var snowTubeNumber: Int = 0
    static var stationIndex: Int = 0 // "None" by default
    static var latitude: Double! = nil
    static var longitude: Double! = nil
    static var date: Date! = nil
    static var startTime: Date! = nil
    static var endTime: Date! = nil
    static var skyAnalysis: SkyAnalysis = SkyAnalysis.none
    static var snowState: SnowState = SnowState.none
    static var snowfallLast24hours: SnowfallLast24hours = SnowfallLast24hours.YES
    static var patchinessPercentage: Int = 0
    static var patchiness: Patchiness = Patchiness.none
    static var snowSurfaceIndex: Int = 0 // "Current" by default
    static var groundCover: GroundCover = GroundCover.none
    static var otherGroundCover: String = "" // non-empty if other ground cover applies
    static var snowSurfaceAge: SnowSurfaceAge = SnowSurfaceAge.none
    static var snowmelt: SnowMelt = SnowMelt.YES
    static var photoDownRGB: [CGFloat] = []
    static var photoUpRGB: [CGFloat] = []
    static var albedo: String = ""
    
    static var snowDepth: Double? = nil
    static var snowWeight: Double? = nil
    static var snowTubeTareWeight = Double.nan
    static var snowTemp: Double = Double.nan
    static var depthUnits: LengthUnit = LengthUnit.inches // Inches by default
    static var weightUnits: WeightUnit = WeightUnit.pounds // Pounds by default
    static var debrisDescription: String = ""
    
    // JSON info
    struct StationInfo: Codable
    {
        var id: Int //ex: 47
        var station_id: String //ex: "NH-GR-1"
        var lon: Double //ex: -71.7414
        var lat: Double //ex: 43.5949
        var date_modified: String //ex: "2016-09-26T11:53:11.016"
    }
    
    struct TubeInfo: Codable
    {
        var id: Int //ex: 3
        var tube_number: String //ex: "13"
        var tube_weight: Double? //ex: null or 1.2 or 1.205
        var station: Int //ex: 2
    }
    
    /*struct UserInfo: Codable
    {
        var id: Int //ex: 48
        var username: String //ex: "AlbedoDev"
    }*/
    
    struct DataEntryInfo: Codable
    {
        var id: Int
        var user_id: Int
        var date: String
        var station_Number: String
        var observation_Date: Date
        var observation_Time: String
        var end_Albedo_Observation_Time: String
        var cloud_Coverage: String
        var incoming_Shortwave_1: Double
        var incoming_Shortwave_2: Double
        var incoming_Shortwave_3: Double
        var outgoing_Shortwave_1: Double
        var outgoing_Shortwave_2: Double
        var outgoing_Shortwave_3: Double
        var tube_Number: Int
        var snow_Depth: Double?
        var snow_Weight_with_tube: Double?
        var snow_Tube_Tare_Weight: Double

        var snowing_At_Observation: String
        var snowfall_Last_24Hours: String
        var observation_Notes: String
        var albedo: Double
        var snow_density: Double
        var surface_Skin_Temperature: String?
    }
    

    static func calculateAlbedo() {
        if PhotoData.photoDownRGB.isEmpty && PhotoData.photoUpRGB.isEmpty { // error check: this function only works if there are two sample buffers
            print("Error - there must be at least two photos to calculate.")
            return
        }
        
        let albedoR: Double = Double(photoDownRGB[0]) / Double(photoUpRGB[0]) // calculate albedo for R
        let albedoG: Double = Double(photoDownRGB[1]) / Double(photoUpRGB[1]) // calculate albedo for G
        let albedoB: Double = Double(photoDownRGB[2]) / Double(photoUpRGB[2]) // calculate albedo for B
        let albedo: Double = albedoR + albedoG + albedoB
        
        // format albedo to 6 decimal places
        PhotoData.albedo = String(format: "%.6f", arguments: [albedo])
        
        print("******* Albedo Value: \(PhotoData.albedo)")
    }
    //?
    static func clearData() {
        userID = 0
        snowTubeNumber = 0
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
        
        
        RootViewController.picturesTaken = false
        photoDownRGB.removeAll()
        photoUpRGB.removeAll()
        albedo = ""
        
        snowDepth = nil
        snowWeight = nil
        snowTubeTareWeight = Double.nan
        snowTemp = Double.nan
        depthUnits = LengthUnit.inches
        weightUnits = WeightUnit.pounds
        debrisDescription = ""
    }
}

enum SkyAnalysis: String {
    case none = "None" // default value
    case allClear = "ACLR" // All clear
    case clear = "CLR" // Clear
    case cloudy = "PCL" // Partly cloudy
    case overcast = "OVC" // Overcast
    
    var description: String {
        switch self {
        case .none:
            return "None"
        case .allClear:
            return "All Clear"
        case .clear:
            return "Clear"
        case .cloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        }
    }
}

enum SnowState: String {
    case none = "N/A" // default value
    case snowCovered = "SC"
    case patchySnow = "PS"
    case snowFreeDormant = "SFD"
    case snowFreeGreen = "SFG"
}


enum SnowMelt: String {
    case YES = "Y"
    case NO = "N"
}

enum SnowfallLast24hours: String {
    case YES = "Y"
    case NO = "N"
}

enum GroundCover: String {
    case none = "None" // default value
    case grassLiving = "GL"
    case grassDead = "GD"
    case wetSoil = "WS"
    case drySoil = "DS"
    case pavement = "P"
    case woodenDeck = "WD"
    case other = "Ot"
}

enum Patchiness: String {
    case none = "" // default value
    case s10 = "10"
    case s20 = "20"
    case s30 = "30"
    case s40 = "40"
    case s50 = "50"
    case s60 = "60"
    case s70 = "70"
    case s80 = "80"
    case s90 = "90"
}

enum SnowSurfaceAge: String {
    case none = "" // default value
    case snow1Day = "<1d"
    case snow2Days = "1d"
    case snow3Days = "2d"
    case snow4Days = "3d"
    case snow5Days = "4d"
    case snow6Days = "5d"
    case snow1Week = "6d"
    case snow2Weeks = "1w"
    case snow3Weeks = "2w"
    case snow4Weeks = "3w"
    case snowAtLeast4Weeks = "4w"
}
//remember, when we upload it to server, the unit gonna transfer to cm automatically
// determine if the unit is inch and transfer before upload.
enum LengthUnit: String {
    case inches = "in"
    case centimeters = "cm"
}

enum WeightUnit: String {
    case pounds = "lbs"
    case grams = "g"
}
