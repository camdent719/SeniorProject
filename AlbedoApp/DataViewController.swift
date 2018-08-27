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
    
    @IBOutlet weak var lblSnowDepth: UILabel!
    @IBOutlet weak var lblSnowWeight: UILabel!
    @IBOutlet weak var lblSnowTubeTareWeight: UILabel!
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
        
        if PhotoData.albedo == "nan" {
            lblAlbedo.text = "None"
        }
        else {
            lblAlbedo.text = PhotoData.albedo
        }
        
        lblSky.text = PhotoData.skyAnalysis.rawValue
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
        
        if !PhotoData.snowDepth.isNaN {
            lblSnowDepth.text = String(PhotoData.snowDepth)
        }
        else {
            lblSnowDepth.text = "---"
        }
        
        if !PhotoData.snowWeight.isNaN {
            lblSnowWeight.text = String(PhotoData.snowWeight)
        }
        else {
            lblSnowWeight.text = "---"
        }
        
        if !PhotoData.snowTubeTareWeight.isNaN {
            lblSnowTubeTareWeight.text = String(PhotoData.snowTubeTareWeight)
        }
        else {
            lblSnowTubeTareWeight.text = "---"
        }
        
        if !PhotoData.snowTemp.isNaN {
            lblSnowTemp.text = String(PhotoData.snowTemp)
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
}
