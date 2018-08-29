//
//  WelcomeViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 4/4/18.
//

import UIKit

class NewMeasurementViewController: UIViewController {
    
    private var prevViewName = "HistoryViewController"
    
    @IBAction func btnTrashTapped(_ sender: Any) {
        // display a popup box to ask if user really wants to discard this albedo measurement and return to the main screen
        openDiscardAlertView()
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        //need to save data to server (or locally if no connection is available), clear PhotoData fields, and return to the home screen
        
        //TODO: save data
        
        clearAndReturnHome()
    }
    
    func openDiscardAlertView() {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to discard this measurement and return to the main screen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.clearAndReturnHome()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearAndReturnHome() {
        PhotoData.clearData()
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: self.prevViewName))!
        self.present(prevViewController, animated: true)
    }
}
