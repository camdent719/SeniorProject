//
//  SkyViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/27/18.
//

import UIKit

class SkyViewController: UIViewController {

    @IBOutlet weak var btnAllClear: UIImageView!
    @IBOutlet weak var btnClear: UIImageView!
    @IBOutlet weak var btnCloudy: UIImageView!
    @IBOutlet weak var btnOvercast: UIImageView!
    
    private let nextViewName = "SnowStateViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allClearTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(allClearTapped(allClearTapped:)))
        btnAllClear.isUserInteractionEnabled = true
        btnAllClear.addGestureRecognizer(allClearTapped)
        
        let clearTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearTapped(clearTapped:)))
        btnClear.isUserInteractionEnabled = true
        btnClear.addGestureRecognizer(clearTapped)
        
        let cloudyTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cloudyTapped(cloudyTapped:)))
        btnCloudy.isUserInteractionEnabled = true
        btnCloudy.addGestureRecognizer(cloudyTapped)
        
        let overcastTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(overcastTapped(overcastTapped:)))
        btnOvercast.isUserInteractionEnabled = true
        btnOvercast.addGestureRecognizer(overcastTapped)
    }
    
    func allClearTapped(allClearTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.allClear
    }
    
    func clearTapped(clearTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.clear
    }
    
    func cloudyTapped(cloudyTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.cloudy
    }
    
    func overcastTapped(overcastTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.overcast
    }
}
