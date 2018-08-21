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
    
    private var currPatchyVal: Int = 0
    private let nextViewName = "GroundCoverViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PhotoData.patchinessPercentage > 0 && PhotoData.patchinessPercentage < 100 {
            // if we pressed next on the patchiness screen, show the last value we had
            currPatchyVal = PhotoData.patchinessPercentage
        }
        else {
            // we have not moved the slider yet or we chose another snow state previously
            currPatchyVal = 50; // default value
        }
        slider.setValue(Float(currPatchyVal), animated: false)
        lblValue.text = "\(currPatchyVal)% Covered"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let val: Float = Float(Int((slider.value + 5) / 10 ) * 10) // restrict to multiples of 10
        slider.setValue(val, animated: false)
        currPatchyVal = Int(sender.value)
        lblValue.text = "\(currPatchyVal)% Covered"
        //PhotoData.patchinessPercentage = currPatchyVal // remember if slider was moved
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        PhotoData.patchinessPercentage = currPatchyVal
    }
}
