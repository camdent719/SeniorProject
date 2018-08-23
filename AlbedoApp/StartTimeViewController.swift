//
//  StartTimeViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 8/10/18.
//

import UIKit

class StartTimeViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PhotoData.date != nil && PhotoData.startTime != nil
        {
            datePicker.setDate(PhotoData.date, animated: false)
            timePicker.setDate(PhotoData.startTime, animated: false)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        PhotoData.date = datePicker.date
        PhotoData.startTime = timePicker.date
        
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController"))!
        self.present(prevViewController, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        PhotoData.date = datePicker.date
        PhotoData.startTime = timePicker.date
    }
}
