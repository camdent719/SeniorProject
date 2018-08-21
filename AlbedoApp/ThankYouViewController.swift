//
//  ThankYouViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 8/20/18.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var btnReturnHome: UIButton!
    
    @IBAction func btnReturnHomeTapped(_ sender: Any) {
        // clear anything from previous submissions
        PhotoData.clearData()
    }
}
