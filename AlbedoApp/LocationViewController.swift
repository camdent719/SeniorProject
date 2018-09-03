//
//  LocationViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 8/10/18.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    struct LocationPair {
        // represent latitude and longitude as strings to avoid floating-point rounding issues
        var latitude: Double!
        var longitude: Double!
    }
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var stationPicker: UIPickerView!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    let formatter = NumberFormatter()
    let locationManager = CLLocationManager()
    
    private var latitudeStartingText: String = ""
    private var longitudeStartingText: String = ""
    private var prevViewName = "NewMeasurementViewController"
    static let stationNames = ["None", "NH-BK-24", "NH-CH-19", "NH-CS-7", "NH-CS-10", "NH-GR-1", "NH-GR-11", "NH-HL-25", "NH-HL-58", "NH-MR-4", "NH-MR-6", "NH-MR-58", "NH-RC-46", "NH-ST-99"]
    static let stationIDs = [-1, 48, 34, 5, 16, 47, 9, 12, 28, 8, 13, 49, 23, 26]
    static let stationLocs = [LocationPair(latitude: nil, longitude: nil), LocationPair(latitude: -71.213364, longitude: 43.437617), LocationPair(latitude: -72.313214, longitude: 42.93995), LocationPair(latitude: -71.57639, longitude: 44.49611), LocationPair(latitude: -71.269535, longitude: 44.388238), LocationPair(latitude: -71.7414, longitude: 43.5949), LocationPair(latitude: -71.688856, longitude: 43.760317), LocationPair(latitude: -71.610217, longitude: 42.914089), LocationPair(latitude: -71.472811, longitude: 42.739811), LocationPair(latitude: -71.556467, longitude: 43.149944), LocationPair(latitude: -71.819, longitude: 43.52), LocationPair(latitude: -71.4697, longitude: 43.2783), LocationPair(latitude: -70.999, longitude: 43.0171), LocationPair(latitude: -70.94871, longitude: 43.10876)]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LocationViewController.stationNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LocationViewController.stationNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // edit text fields to corresponding latitude and longitude
        if row == 0 {
            latitudeTextField.text = ""
            longitudeTextField.text = ""
        }
        else {
            latitudeTextField.text = formatter.string(from: LocationViewController.stationLocs[row].latitude! as NSNumber)!
            longitudeTextField.text = formatter.string(from: LocationViewController.stationLocs[row].longitude! as NSNumber)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // round up to six decimal places
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 1
        
        stationPicker.selectRow(PhotoData.stationIndex, inComponent: 0, animated: false)
        if PhotoData.latitude == nil {
            latitudeTextField.text = ""
        }
        else {
            latitudeTextField.text = formatter.string(from: PhotoData.latitude! as NSNumber)!
            
        }
        if PhotoData.longitude == nil {
            longitudeTextField.text = ""
        }
        else {
            longitudeTextField.text = formatter.string(from: PhotoData.longitude! as NSNumber)!
        }
    }
    
    // if the user taps outside of the keyboard, dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func latitudeEditingBegan(_ sender: Any) {
        latitudeStartingText = latitudeTextField.text!
    }
    
    @IBAction func latitudeEditingEnded(_ sender: Any) {
        if latitudeStartingText != latitudeTextField.text! {
            // reset picker to None if the latitude changed
            stationPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func longitudeEditingBegan(_ sender: Any) {
        longitudeStartingText = longitudeTextField.text!
    }
    
    @IBAction func longitudeEditingEnded(_ sender: Any) {
        if longitudeStartingText != longitudeTextField.text! {
            // reset picker to None if the longitude changed
            stationPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        let currentRow = stationPicker.selectedRow(inComponent: 0)
        if currentRow != 0 {
            if LocationViewController.stationLocs[currentRow].latitude! != Double(latitudeTextField.text!) || LocationViewController.stationLocs[currentRow].longitude! != Double(longitudeTextField.text!) {
                PhotoData.stationIndex = 0
            }
            else {
                PhotoData.stationIndex = currentRow
            }
        }
        else {
            PhotoData.stationIndex = 0
        }
        
        if (latitudeTextField.text?.isEmpty)! || (longitudeTextField.text?.isEmpty)! {
            // cannot procede until location is entered; show an error popup
            let alert = UIAlertController(title: "Warning", message: "Latitude and/or longitude are empty. Please enter both before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                print("cancelled")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if let latitude =  Double(latitudeTextField.text!) {
                PhotoData.latitude = latitude
            }
            else {
                // A valid latitude was not entered. Try again.
                let alert = UIAlertController(title: "Warning", message: "Latitude is not a number. Please enter a valid number for latitude before continuing.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    print("cancelled")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            if let longitude = Double(longitudeTextField.text!) {
                PhotoData.longitude = longitude
            }
            else {
                // A valid longitude was not entered. Try again.
                let alert = UIAlertController(title: "Warning", message: "Longitude is not a number. Please enter a valid number for longitude before continuing.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    print("cancelled")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        //remember current selections
        let currentRow = stationPicker.selectedRow(inComponent: 0)
        if currentRow != 0 {
            if LocationViewController.stationLocs[currentRow].latitude! != Double(latitudeTextField.text!) || LocationViewController.stationLocs[currentRow].longitude! != Double(longitudeTextField.text!) {
                PhotoData.stationIndex = 0
            }
            else {
                PhotoData.stationIndex = currentRow
            }
        }
        else {
            PhotoData.stationIndex = 0
        }
        
        if (latitudeTextField.text?.isEmpty)! {
            // Nothing is entered for latitude
            PhotoData.latitude = nil
        }
        else if let latitude =  Double(latitudeTextField.text!) {
            PhotoData.latitude = latitude
        }
        if (longitudeTextField.text?.isEmpty)! {
            // Nothing is entered for longitude
            PhotoData.longitude = nil
        }
        else if let longitude = Double(longitudeTextField.text!) {
            PhotoData.longitude = longitude
        }
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: prevViewName))!
        self.present(prevViewController, animated: true)
    }
    
    @IBAction func btnCurrLocationTapped(_ sender: Any) {
        // get user's location
        self.locationManager.requestWhenInUseAuthorization() // user must agree to use location (first time only)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // set latitude and longitude textboxes
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else {
            // failed to get location
            let alert = UIAlertController(title: "Error", message: "Failed to get current location. Please make sure location permissions are enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        latitudeTextField.text = formatter.string(from: location.latitude as NSNumber)!
        longitudeTextField.text = formatter.string(from: location.longitude as NSNumber)!
        
        // reset picker to None
        stationPicker.selectRow(0, inComponent: 0, animated: true)
    }
}
