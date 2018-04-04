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

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if PhotoData.snowState == SnowState.snowFreeDormant || PhotoData.snowState == SnowState.snowFreeGreen {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowStateViewController"))!
            self.present(prevViewController, animated: true)
        } else {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowSurfaceViewController"))!
            self.present(prevViewController, animated: true)
        }
    }
}
