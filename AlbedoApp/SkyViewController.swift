//
//  SkyViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/27/18.
//

import UIKit

class SkyViewController: UIViewController {

    @IBOutlet weak var btnNoCloud: UIImageView!
    @IBOutlet weak var btnCloud: UIImageView!
    @IBOutlet weak var btnObstructed: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let noCloudGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(noCloudGestureTapped(noCloudGesture:)))
        btnNoCloud.isUserInteractionEnabled = true
        btnNoCloud.addGestureRecognizer(noCloudGesture)
        
        let cloudGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cloudGestureTapped(cloudGesture:)))
        btnCloud.isUserInteractionEnabled = true
        btnCloud.addGestureRecognizer(cloudGesture)
        
        let obstructedGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(obstructedGestureTapped(obstructedGesture:)))
        btnObstructed.isUserInteractionEnabled = true
        btnObstructed.addGestureRecognizer(obstructedGesture)
        
    }
    
    func noCloudGestureTapped(noCloudGesture: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SkyColorViewController"))!
        self.present(nextViewController, animated: true)
    }
    
    func cloudGestureTapped(cloudGesture: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CloudCoverageViewController"))!
        self.present(nextViewController, animated: true)
    }
    
    func obstructedGestureTapped(obstructedGesture: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ObstructionViewController"))!
        self.present(nextViewController, animated: true)
    }
}
