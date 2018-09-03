//
//  DataViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/23/18.
//

import UIKit
import MapKit
import CoreLocation

class DataViewController: UIViewController, CLLocationManagerDelegate {
    
    let formatter = NumberFormatter()
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet weak var lblAlbedo: UILabel!
    
    @IBOutlet weak var lblSky: UILabel!
    @IBOutlet weak var lblSnowState: UILabel!
    @IBOutlet weak var lblGroundCover: UILabel!
    @IBOutlet weak var lblSnowSurface: UILabel!
    
    @IBOutlet weak var lblSnowDepthName: UILabel!
    @IBOutlet weak var lblSnowDepthValue: UILabel!
    @IBOutlet weak var lblSnowWeightName: UILabel!
    @IBOutlet weak var lblSnowWeightValue: UILabel!
    @IBOutlet weak var lblSnowTubeTareWeightName: UILabel!
    @IBOutlet weak var lblSnowTubeTareWeightValue: UILabel!
    @IBOutlet weak var lblSnowTemp: UILabel!
    
    @IBOutlet weak var lblDebrisDesc: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user's location
        self.locationManager.requestWhenInUseAuthorization() // user must agree to use location (first time only)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // formatter rounds to six decimal places
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 1
        
        // update labels
        
        // format date/time data
        /*let startDate = PhotoData.startDate.index(PhotoData.startDate.startIndex, offsetBy: 0)
        let endDate = PhotoData.startDate.index(PhotoData.startDate.startIndex, offsetBy: 9)
        let dateRange = startDate...endDate
        let date: String = PhotoData.startDate[dateRange]
        
        let startTime = PhotoData.startTime.index(PhotoData.startTime.startIndex, offsetBy: 11)
        let endTime = PhotoData.startTime.index(PhotoData.startTime.startIndex, offsetBy: 18)
        let timeRange = startTime...endTime
        let time = PhotoData.startTime[timeRange]
        
        let startTime2 = PhotoData.endTime.description.index(PhotoData.endTime.startIndex, offsetBy: 11)
        let endTime2 = PhotoData.endTime.index(PhotoData.endTime.startIndex, offsetBy: 18)
        let timeRange2 = startTime2...endTime2
        let time2 = PhotoData.endTime[timeRange2]
        
        print(date)
        print(time)*/
        
        lblLatitude.text = String(PhotoData.latitude)
        lblLongitude.text = String(PhotoData.longitude)
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        lblDate.text = dateFormatter.string(from: PhotoData.date)
        lblStartTime.text = timeFormatter.string(from: PhotoData.startTime)
        lblEndTime.text = timeFormatter.string(from: PhotoData.endTime)
        
        if PhotoData.albedo == "" {
            lblAlbedo.text = "None"
        }
        else {
            lblAlbedo.text = PhotoData.albedo
        }
        
        lblSky.text = PhotoData.skyAnalysis.description
        
        if PhotoData.patchinessPercentage != 0 {
            lblSnowState.text = PhotoData.snowState.rawValue + ", \(PhotoData.patchinessPercentage)% patchiness"
        }
        else {
            lblSnowState.text = PhotoData.snowState.rawValue
        }
        
        if (PhotoData.groundCover == GroundCover.other) {
            lblGroundCover.text = PhotoData.otherGroundCover
        }
        else {
            lblGroundCover.text = PhotoData.groundCover.rawValue
        }
        
        lblSnowSurface.text = PhotoData.snowSurfaceAge.rawValue
        
        if PhotoData.depthUnits == LengthUnit.inches {
            lblSnowDepthName.text = "Snow Depth (in):"
        }
        else {
            lblSnowDepthName.text = "Snow Depth (cm):"
        }
        
        if let depth = PhotoData.snowDepth {
            if !depth.isNaN {
                lblSnowDepthValue.text = formatter.string(from: depth as NSNumber)!
            }
            else {
                lblSnowDepthValue.text = "---"
            }
        }
        else {
            lblSnowDepthValue.text = "---"
        }
        
        if PhotoData.weightUnits == WeightUnit.pounds {
            lblSnowWeightName.text = "Snow Weight (lbs):"
            lblSnowTubeTareWeightName.text = "Snow Tube Tare Weight (lbs):"
        }
        else {
            lblSnowWeightName.text = "Snow Weight (kg):"
            lblSnowTubeTareWeightName.text = "Snow Tube Tare Weight (kg):"
        }
        
        if let weight = PhotoData.snowWeight {
            if !weight.isNaN {
                lblSnowWeightValue.text = formatter.string(from: weight as NSNumber)!
            }
            else {
                lblSnowWeightValue.text = "---"
            }
        }
        else {
            lblSnowWeightValue.text = "---"
        }
        
        if !PhotoData.snowTubeTareWeight.isNaN {
            lblSnowTubeTareWeightValue.text = formatter.string(from: PhotoData.snowTubeTareWeight as NSNumber)!
        }
        else {
            lblSnowTubeTareWeightValue.text = "---"
        }
        
        if !PhotoData.snowTemp.isNaN {
            lblSnowTemp.text = formatter.string(from: PhotoData.snowTemp as NSNumber)!
        }
        else {
            lblSnowTemp.text = "---"
        }
        
        if PhotoData.debrisDescription != "" {
            lblDebrisDesc.text = PhotoData.debrisDescription
        }
        else {
            lblDebrisDesc.text = "---"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let strLoc = printLocation(manager: locationManager)
        //lblLatitude.text = roundToFourPlaces(num: strLoc.0)
        //lblLongitude.text = roundToFourPlaces(num: strLoc.1)
    }
    
    // returns a tuple with string representations of the current latitude and longitude
    func printLocation(manager: CLLocationManager) -> (latitude: String, longitude: String) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {
            print("Error - could not get location")
            return ("", "")
        }
        return ("\(location.latitude)", "\(location.longitude)")
    }
    
    // returns the current date formatted as: March 23, 2018
    func getDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: today)
    }
    
    // returns the current time formatted as: 4:44 PM
    func getTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: now)
    }
    
    // rounds a number to 4 decimal places
    func roundToFourPlaces(num: String) -> String {
        return String(round(10000 * Double(num)!) / 10000)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        // Encapsulate station, tube, and measurement info into three separate structs, which will be encoded into JSON
        let station = LocationViewController.stationNames[PhotoData.stationIndex]
        let stationID = LocationViewController.stationIDs[PhotoData.stationIndex]
        
        var snowWithin24Hrs: String = "N" // Y = yes; N = no
        if PhotoData.snowSurfaceAge == SnowSurfaceAge.current || PhotoData.snowSurfaceAge == SnowSurfaceAge.snow1Day {
            snowWithin24Hrs = "Y"
        }
        
        var snowingAtObservation: String = "N" // Y = yes; N = no
        if PhotoData.snowSurfaceAge == SnowSurfaceAge.current {
            snowingAtObservation = "Y"
        }
        
        let stationInfo = PhotoData.StationInfo(id: PhotoData.userID, station_id: station, lon: PhotoData.longitude, lat: PhotoData.latitude, date_modified: Date().description)
        
        let tubeInfo = PhotoData.TubeInfo(id: PhotoData.userID, tube_number: String(PhotoData.snowTubeNumber), tube_weight: PhotoData.snowTubeTareWeight, station: stationID)
        
        //var userInfo = PhotoData.UserInfo()
        
        var albedoVal: Double = Double.nan
        if !PhotoData.albedo.isEmpty {
            albedoVal = Double(PhotoData.albedo)!
        }
        
        let measurementInfo = PhotoData.DataEntryInfo(
            id: -1, // Unique for each measurement (determined by server)?
            user_id: PhotoData.userID,
            date: "", // Automatically generated by the server (or use Date().description?)?
            station_Number: station,
            observation_Date: PhotoData.date,
            observation_Time: PhotoData.startTime.description,
            end_Albedo_Observation_Time: PhotoData.endTime.description,
            cloud_Coverage: PhotoData.skyAnalysis.rawValue,
            incoming_Shortwave_1: Double.nan,
            incoming_Shortwave_2: Double.nan,
            incoming_Shortwave_3: Double.nan,
            outgoing_Shortwave_1: Double.nan,
            outgoing_Shortwave_2: Double.nan,
            outgoing_Shortwave_3: Double.nan,
            tube_Number: Int(PhotoData.snowTubeNumber),
            snow_Depth: PhotoData.snowDepth,
            snow_Weight_with_tube: PhotoData.snowWeight,
            snow_Tube_Tare_Weight: PhotoData.snowTubeTareWeight,
            snowing_At_Observation: snowingAtObservation,
            snowfall_Last_24Hours: snowWithin24Hrs,
            observation_Notes: PhotoData.debrisDescription,
            albedo: albedoVal,
            snow_density: (PhotoData.snowWeight! / PhotoData.snowDepth!),
            surface_Skin_Temperature: String(PhotoData.snowTemp))
        
        // Encode data for JSON POST requests to the server.
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonStationData = try encoder.encode(stationInfo)
            if let encodedJSONString = String(data: jsonStationData, encoding: .utf8) {
                print("STATION INFO")
                print(encodedJSONString) // Can use this to see the JSON string before it is sent
                
                // Send the station info
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            let jsonTubeData = try encoder.encode(tubeInfo)
            if let encodedJSONString = String(data: jsonTubeData, encoding: .utf8) {
                print("TUBE INFO")
                print(encodedJSONString) // Can use this to see the JSON string before it is sent
                
                // Send the tube info
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            let jsonMeasurementData = try encoder.encode(measurementInfo)
            if let encodedJSONString = String(data: jsonMeasurementData, encoding: .utf8) {
                print("DATA ENTRY INFO")
                print(encodedJSONString) // Can use this to see the JSON string before it is sent
                
                // Send the measurement info
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Respond to JSON GET requests from the server.
        /*let jsonGetRequestData = """
{
    "first_name": "John",
    "last_name": "Doe",
    "country": "United Kingdom"
}
"""
        
        // Send the information to the server
        if let jsonData = jsonGetRequestData.data(using: .utf8) {
            // Use jsonData
            let jsonDecoder = JSONDecoder()
            do {
                let user = try! jsonDecoder.decode(PhotoData.Measurement.self, from: jsonData)
                print(user.lastName!)
            } catch {
                print(error.localizedDescription)
            }
        }
        else {
            // Respond to error
            
        }*/
        
        // reset all local data after submitting
        PhotoData.clearData()
    }
}
