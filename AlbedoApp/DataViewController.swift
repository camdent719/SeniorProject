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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get user's location
        self.locationManager.requestWhenInUseAuthorization() // user must agree to use location (first time only)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // update labels
        let strLoc = printLocation(manager: locationManager)
        lblLatitude.text = strLoc.0
        lblLongitude.text = strLoc.1
        lblDate.text = getDate()
        lblTime.text = getTime()
        lblAlbedo.text = PhotoData.albedo
    }
    
    func printLocation(manager: CLLocationManager) -> (latitude: String, longitude: String) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {
            print("Error - could not get location")
            return ("", "")
        }
        return ("\(location.latitude)", "\(location.longitude)")
    }
    
    func getDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: today) // March 23, 2018
    }
    
    func getTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: now) // 4:44 PM
    }
}
