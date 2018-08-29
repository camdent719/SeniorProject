//
//  SnowSurfaceAgeViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class SnowSurfaceAgeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var agePicker: UIPickerView!
    
    private let nextViewName = "GroundCoverViewController"
    let snowAges = ["Currently Snowing", "< 1 Day Old", "1 Day Old", "2 Days Old", "3 Days Old", "4 Days Old", "5 Days Old", "6 Days Old", "1 Week Old", "2 Weeks Old", "3 Weeks Old", "4+ Weeks Old"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return snowAges[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return snowAges.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agePicker.selectRow(PhotoData.snowSurfaceIndex, inComponent: 0, animated: false)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        // Save the freshness
        let selectedRow = agePicker.selectedRow(inComponent: 0)
        PhotoData.snowSurfaceIndex = selectedRow
        switch selectedRow {
        case 0:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.current
        case 1:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow1Day
        case 2:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow2Days
        case 3:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow3Days
        case 4:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow4Days
        case 5:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow5Days
        case 6:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow6Days
        case 7:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow1Week
        case 8:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow2Weeks
        case 9:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow3Weeks
        case 10:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow4Weeks
        case 11:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snowAtLeast4Weeks
        default:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.none
        }
        
        // Is the snow patchy? If so, go back to the patchiness view controller. Otherwise, go to the snow surface view controller.
        if PhotoData.patchinessPercentage > 0 && PhotoData.patchinessPercentage < 100 {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PatchinessViewController"))!
            self.present(prevViewController, animated: true)
        } else {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowStateViewController"))!
            self.present(prevViewController, animated: true)
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        // Save the freshness
        let selectedRow = agePicker.selectedRow(inComponent: 0)
        PhotoData.snowSurfaceIndex = selectedRow
        switch selectedRow {
        case 0:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.current
        case 1:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow1Day
        case 2:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow2Days
        case 3:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow3Days
        case 4:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow4Days
        case 5:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow5Days
        case 6:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow6Days
        case 7:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow1Week
        case 8:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow2Weeks
        case 9:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow3Weeks
        case 10:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snow4Weeks
        case 11:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.snowAtLeast4Weeks
        default:
            PhotoData.snowSurfaceAge = SnowSurfaceAge.none
        }
    }
}


