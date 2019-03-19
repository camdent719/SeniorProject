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
    let ID = UserDefaults.standard.integer(forKey: "ID")
    
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
        lblLatitude.text = String(PhotoData.latitude)
        lblLongitude.text = String(PhotoData.longitude)
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
       
        dateFormatter.timeStyle = .none
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
       // timeFormatter.timeFormat = "yyyy-MM-dd"
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
        if PhotoData.snowSurfaceAge == SnowSurfaceAge.none || PhotoData.snowSurfaceAge == SnowSurfaceAge.snow1Day {
            snowWithin24Hrs = "Y"
        }
        
        var snowingAtObservation: String = "N" // Y = yes; N = no
        if PhotoData.snowSurfaceAge == SnowSurfaceAge.none {
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
            
            //here
            observation_Date: PhotoData.date,
            //here
            observation_Time: PhotoData.startTime.description,
            //here
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
            print("ERROR")
            print("ID")
            print(ID)
            print(error.localizedDescription)
        }
        

        let d = DataEntry(user:ID,
                          station_Number: tubeInfo.station,
                          observation_Date:PhotoData.date.description,
                          observation_Time:PhotoData.startTime.description,
                          end_Albedo_Observation_time: PhotoData.skyAnalysis.rawValue,
                          cloud_Coverage: PhotoData.skyAnalysis.rawValue,
                          incoming_Shortwave_1: Float(2),
                          incoming_Shortwave_2: Float(2),
                          incoming_Shortwave_3: Float(2),
                          outgoing_Shortwave_1: Float(2),
                          outgoing_Shortwave_2: Float(2),
                          outgoing_Shortwave_3: Float(2),
                          surface_Skin_Temperature: String(PhotoData.snowTemp),
                          tube_Number:Int(PhotoData.snowTubeNumber),
                          snowfall_Last_24hours: PhotoData.snowfallLast24hours.rawValue,
                          snow_Melt:PhotoData.snowmelt.rawValue,
                          snow_state: PhotoData.snowState.rawValue,
                          snow_Depth :Double(PhotoData.snowDepth!),
                          patchiness: PhotoData.patchiness.rawValue,
                          snow_surface_age: PhotoData.snowSurfaceAge.rawValue,
                          ground_cover: PhotoData.groundCover.rawValue,
                          lat: 0,
                          lon: 0,
                          snow_tube_cap_weight :PhotoData.snowWeight!,
                          tube_cap_weight: 0)
                    self.postReqest(data: d);

                    PhotoData.clearData()
    }
    func postReqest(data:DataEntry) {
        //creating a NSURL
        
        //fetching the data from the url
        let url = URL(string: "http://albedo.gsscdev.com/api/data-entries/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token 8d0996bc46f6d1bb47795ee70fc74d8c226e2ea1", forHTTPHeaderField: "Authorization")
        
        do {
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            print(jsonData)
            urlRequest.httpBody = jsonData
            print("asdasdasdasdasdasdasdasdasd")
          //  print(id)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
        } catch { print("HELLLO ");print(error) }
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
            
            print("POST")
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            print(responseJSON)
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
            }
            /*  else
             print("jsonObj TEST")
             */
        }).resume()
    }
    //init
    struct DataEntry: Codable{
        init(
            user: Int = 79,
            station_Number: Int = 0,
            observation_Date: String = "2011-12-07",
            observation_Time: String  = "10:30:00",
            end_Albedo_Observation_time: String = "11:31:00",
            cloud_Coverage: String = "",
            incoming_Shortwave_1: Float = 0,
            incoming_Shortwave_2: Float = 0,
            incoming_Shortwave_3: Float = 0,
            outgoing_Shortwave_1: Float = 0,
            outgoing_Shortwave_2: Float = 0,
            outgoing_Shortwave_3: Float = 0,
            surface_Skin_Temperature: String = "0",
            tube_Number: Int = 2,
            snowfall_Last_24hours: String = "0",
            snow_Melt: String = "0",
            snow_state: String = "0",
            snow_Depth: Double = 0,
            patchiness: String = "",
            snow_surface_age: String = "0",
            ground_cover: String = "0",
            lat:Float = 0,
            lon:Float = 0,
            snow_tube_cap_weight: Double = 0,
            tube_cap_weight: Float = 0
            ) {
            self.user = user
            self.station_Number = station_Number
            self.observation_Date = "2011-12-07"
            self.observation_Time = "10:30:00"
            self.end_Albedo_Observation_time = "11:31:00"
            self.cloud_Coverage = cloud_Coverage
            self.incoming_Shortwave_1 = incoming_Shortwave_1
            self.incoming_Shortwave_2 = incoming_Shortwave_2
            self.incoming_Shortwave_3 = incoming_Shortwave_3
            self.outgoing_Shortwave_1 = outgoing_Shortwave_1
            self.outgoing_Shortwave_2 = outgoing_Shortwave_2
            self.outgoing_Shortwave_3 = outgoing_Shortwave_3
            self.surface_Skin_Temperature = surface_Skin_Temperature
            self.tube_Number = tube_Number
            self.snowfall_Last_24hours = snowfall_Last_24hours
            self.snow_Melt = snow_Melt
            self.snow_state = snow_state
            self.snow_surface_age = snow_surface_age
            self.patchiness = patchiness
            self.ground_cover = ground_cover
            self.lat = lat
            self.lon = lon
            self.snow_tube_cap_weight = Float(snow_tube_cap_weight)
            self.tube_cap_weight = tube_cap_weight
        }
        var user: Int
        var station_Number: Int
        var observation_Date: String
        var observation_Time: String
        var end_Albedo_Observation_time: String
        var cloud_Coverage: String
        var incoming_Shortwave_1: Float
        var incoming_Shortwave_2: Float
        var incoming_Shortwave_3: Float
        var outgoing_Shortwave_1: Float
        var outgoing_Shortwave_2: Float
        var outgoing_Shortwave_3: Float
        var surface_Skin_Temperature: String
        var tube_Number: Int
        var snowfall_Last_24hours: String
        var snow_Melt: String
        var snow_state: String
        var patchiness: String
        var snow_surface_age: String
        var ground_cover: String
        var lat: Float
        var lon: Float
        var snow_tube_cap_weight: Float
        var tube_cap_weight: Float
        
    }
}
