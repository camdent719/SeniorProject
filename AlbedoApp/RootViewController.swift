//
//  RootViewController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/18/17.
//
//  GPS Location code adapted from
//  https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//

import UIKit
import MapKit
import CoreLocation

class RootViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization() // user must agree to use location (first time only)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Current location: \(location.latitude), \(location.longitude)")
    }
}

