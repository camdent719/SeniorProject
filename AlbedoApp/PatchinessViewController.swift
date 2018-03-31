//
//  PatchinessViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class PatchinessViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    private var currVal: Int = 50
    private let nextViewName = "GroundCoverViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let val: Float = Float(Int((slider.value + 5) / 10 ) * 10) // restrict to multiples of 10
        slider.setValue(val, animated: false)
        currVal = Int(sender.value)
        lblValue.text = "\(currVal)% Covered"
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        PhotoData.patchinessPercentage = currVal
    }
}
