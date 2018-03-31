//
//  SkyViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/27/18.
//

import UIKit

class SkyViewController: UIViewController {

    @IBOutlet weak var btnClear: UIImageView!
    @IBOutlet weak var btnMostlyClear: UIImageView!
    @IBOutlet weak var btnCloudy: UIImageView!
    @IBOutlet weak var btnObscured: UIImageView!
    
    private let nextViewName = "SnowStateViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearTapped(clearTapped:)))
        btnClear.isUserInteractionEnabled = true
        btnClear.addGestureRecognizer(clearTapped)
        
        let mostlyClearTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mostlyClearTapped(mostlyClearTapped:)))
        btnMostlyClear.isUserInteractionEnabled = true
        btnMostlyClear.addGestureRecognizer(mostlyClearTapped)
        
        let cloudyTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cloudyTapped(cloudyTapped:)))
        btnCloudy.isUserInteractionEnabled = true
        btnCloudy.addGestureRecognizer(cloudyTapped)
        
        let obscuredTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(obscuredTapped(obscuredTapped:)))
        btnObscured.isUserInteractionEnabled = true
        btnObscured.addGestureRecognizer(obscuredTapped)
    }
    
    func clearTapped(clearTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.clear
    }
    
    func mostlyClearTapped(mostlyClearTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.mostlyClear
    }
    
    func cloudyTapped(cloudyTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.cloudy
    }
    
    func obscuredTapped(obscuredTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.skyAnalysis = SkyAnalysis.obscured
    }
}
