//
//  EndTimeViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 8/10/18.
//

import UIKit

class EndTimeViewController: UIViewController {
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PhotoData.endTime != nil {
            endTimePicker.setDate(PhotoData.endTime, animated: false)
        }
        else if PhotoData.endTime == nil && PhotoData.startTime != nil {
            // set the end time to the start time, by default
            endTimePicker.setDate(PhotoData.startTime, animated: false)
        }
        // if startTime is nil, set endTime to the current time
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        PhotoData.endTime = endTimePicker.date
        
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController"))!
        self.present(prevViewController, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        PhotoData.endTime = endTimePicker.date
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "DataViewController"))!
        self.present(nextViewController, animated: true)
    }
}
