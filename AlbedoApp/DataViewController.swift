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
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAlbedo: UILabel!
    
    @IBOutlet weak var lblSky: UILabel!
    @IBOutlet weak var lblSnowState: UILabel!
    @IBOutlet weak var lblGroundCover: UILabel!
    @IBOutlet weak var lblSnowSurface: UILabel!
    
    @IBOutlet weak var lblSnowDepth: UILabel!
    @IBOutlet weak var lblSnowWeight: UILabel!
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
        let strLoc = printLocation(manager: locationManager)
        lblLatitude.text = roundToFourPlaces(num: strLoc.0)
        lblLongitude.text = roundToFourPlaces(num: strLoc.1)
        lblDate.text = getDate()
        lblTime.text = getTime()
        if PhotoData.albedo == "nan" {
            lblAlbedo.text = "None"
        } else {
            lblAlbedo.text = PhotoData.albedo
        }
        
        lblSky.text = PhotoData.skyAnalysis.rawValue
        if PhotoData.patchinessPercentage != 0 {
            lblSnowState.text = PhotoData.snowState.rawValue + ", \(PhotoData.patchinessPercentage)% patchiness"
        } else {
            lblSnowState.text = PhotoData.snowState.rawValue
        }
        lblGroundCover.text = PhotoData.groundCover.rawValue
        lblSnowSurface.text = PhotoData.snowSurfaceAge.rawValue
        
        if !PhotoData.snowDepth.isNaN {
            lblSnowDepth.text = String(PhotoData.snowDepth)
        } else {
            lblSnowDepth.text = "---"
        }
        
        if !PhotoData.snowWeight.isNaN {
            lblSnowWeight.text = String(PhotoData.snowWeight)
        } else {
            lblSnowWeight.text = "---"
        }
        
        if !PhotoData.snowTemp.isNaN {
            lblSnowTemp.text = String(PhotoData.snowTemp)
        } else {
            lblSnowTemp.text = "---"
        }
        
        if PhotoData.debrisDescription != "" {
            lblDebrisDesc.text = PhotoData.debrisDescription
        } else {
            lblDebrisDesc.text = "---"
        }
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
