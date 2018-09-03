//
//  OptionalDataViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 4/1/18.
//

import UIKit

class OptionalDataViewController: UIViewController {

    @IBOutlet weak var txtFieldSnowDepth: UITextField!
    @IBOutlet weak var txtFieldSnowWeight: UITextField!
    @IBOutlet weak var txtFieldSnowTubeTareWeight: UITextField!
    @IBOutlet weak var txtFieldSnowTemp: UITextField!
    @IBOutlet weak var controlSegmentDepth: UISegmentedControl!
    @IBOutlet weak var controlSegmentWeight: UISegmentedControl!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionalDataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let depth = PhotoData.snowDepth {
            if !depth.isNaN {
                txtFieldSnowDepth.text = String(depth)
            }
        }
        
        if let weight = PhotoData.snowWeight {
            if !weight.isNaN {
                txtFieldSnowWeight.text = String(weight)
            }
        }
        
        if !PhotoData.snowTubeTareWeight.isNaN {
            txtFieldSnowTubeTareWeight.text = String(PhotoData.snowTubeTareWeight)
        }
        
        if !PhotoData.snowTemp.isNaN {
            txtFieldSnowTemp.text = String(PhotoData.snowTemp)
        }
        
        if PhotoData.depthUnits.rawValue == LengthUnit.inches.rawValue {
            controlSegmentDepth.selectedSegmentIndex = 0
        }
        else {
            controlSegmentDepth.selectedSegmentIndex = 1
        }
        
        if PhotoData.weightUnits.rawValue == WeightUnit.pounds.rawValue {
            controlSegmentWeight.selectedSegmentIndex = 0
        }
        else {
            controlSegmentWeight.selectedSegmentIndex = 1
        }
        
        /*controlSegmentDepth.selectedSegmentIndex = PhotoData.depthUnits.hashValue
        controlSegmentWeight.selectedSegmentIndex = PhotoData.weightUnits.hashValue*/
        
        //errSnowDepth.isHidden = true
        //errSnowWeight.isHidden = true
        //errSnowTemp.isHidden = true
    }
   
    // if the user taps outside of the keyboard, dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        let inputSnowDepth = txtFieldSnowDepth.text
        let inputSnowWeight = txtFieldSnowWeight.text
        let inputSnowTubeTareWeight = txtFieldSnowTubeTareWeight.text
        let inputSnowTemp = txtFieldSnowTemp.text
        let values = [inputSnowDepth, inputSnowWeight, inputSnowTubeTareWeight, inputSnowTemp]
        
        let pattern = "^[-+]?[0-9]*\\.?[0-9]+$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        var allValid = true
        for (i, v) in values.enumerated() {
            if (v?.isEmpty)! {
                if i == 0 {
                    txtFieldSnowDepth.layer.borderWidth = 0
                }
                else if i == 1 {
                    txtFieldSnowWeight.layer.borderWidth = 0
                }
                else if i == 2 {
                    txtFieldSnowTubeTareWeight.layer.borderWidth = 0
                }
                else { // i == 3
                    txtFieldSnowTemp.layer.borderWidth = 0
                }
                continue // values are optional, so if empty this is valid
            }
            
            let matches = regex.matches(in: v!, options: [], range: NSRange(location: 0, length: (v!.count)))
            let validColor = UIColor.clear.cgColor
            let errColor = UIColor.red.cgColor
            if i == 0 {
                if matches.count < 1 {
                    //errSnowDepth.isHidden = false
                    txtFieldSnowDepth.layer.borderColor = errColor
                    txtFieldSnowDepth.layer.borderWidth = 2
                    allValid = false
                } else {
                    //errSnowDepth.isHidden = true
                    txtFieldSnowDepth.layer.borderWidth = 0
                    txtFieldSnowDepth.layer.borderColor = validColor
                }
            } else if i == 1 {
                if matches.count < 1 {
                    //errSnowWeight.isHidden = false
                    txtFieldSnowWeight.layer.borderColor = errColor
                    txtFieldSnowWeight.layer.borderWidth = 2
                    allValid = false
                } else {
                    //errSnowWeight.isHidden = true
                    txtFieldSnowWeight.layer.borderWidth = 0
                    txtFieldSnowWeight.layer.borderColor = validColor
                }
            } else if i == 2 {
                if matches.count < 1 {
                    //errSnowTareWeight.isHidden = false
                    txtFieldSnowTubeTareWeight.layer.borderColor = errColor
                    txtFieldSnowTubeTareWeight.layer.borderWidth = 2
                    allValid = false
                } else {
                    //errSnowWeight.isHidden = true
                    txtFieldSnowTubeTareWeight.layer.borderWidth = 0
                    txtFieldSnowTubeTareWeight.layer.borderColor = validColor
                }
            } else { // if i == 3
                if matches.count < 1 {
                    //errSnowTemp.isHidden = false
                    txtFieldSnowTemp.layer.borderColor = errColor
                    txtFieldSnowTemp.layer.borderWidth = 2
                    allValid = false
                } else {
                    //errSnowTemp.isHidden = true
                    txtFieldSnowTemp.layer.borderWidth = 0
                    txtFieldSnowTemp.layer.borderColor = validColor
                }
            }
        }
        
        if allValid {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    @IBAction func depthControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            PhotoData.depthUnits = LengthUnit.inches
        }
        else {
            PhotoData.depthUnits = LengthUnit.centimeters
        }
    }
    
    @IBAction func weightControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            PhotoData.weightUnits = WeightUnit.pounds
        }
        else {
            PhotoData.weightUnits = WeightUnit.grams
        }
    }
    
    // if the user clicks back, they are retaking the photos. Ask them to confirm if they want to do this
    @IBAction func btnBackTapped(_ sender: Any) {
        if !(txtFieldSnowDepth.text?.isEmpty)! {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowDepth = Double.nan
        }
        if !(txtFieldSnowWeight.text?.isEmpty)! {
            PhotoData.snowWeight = (txtFieldSnowWeight.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowWeight = Double.nan
        }
        if !(txtFieldSnowTubeTareWeight.text?.isEmpty)! {
            PhotoData.snowTubeTareWeight = (txtFieldSnowTubeTareWeight.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowTubeTareWeight = Double.nan
        }
        if !(txtFieldSnowTemp.text?.isEmpty)! {
            PhotoData.snowTemp = (txtFieldSnowTemp.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowTemp = Double.nan
        }
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!
        self.present(prevViewController, animated: true)
    }
    
    // save all data to the PhotoData class
    @IBAction func btnNextTapped(_ sender: Any) {
        if !(txtFieldSnowDepth.text?.isEmpty)! {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowDepth = Double.nan
        }
        if !(txtFieldSnowWeight.text?.isEmpty)! {
            PhotoData.snowWeight = (txtFieldSnowWeight.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowWeight = Double.nan
        }
        if !(txtFieldSnowTubeTareWeight.text?.isEmpty)! {
            PhotoData.snowTubeTareWeight = (txtFieldSnowTubeTareWeight.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowTubeTareWeight = Double.nan
        }
        if !(txtFieldSnowTemp.text?.isEmpty)! {
            PhotoData.snowTemp = (txtFieldSnowTemp.text! as NSString).doubleValue
        }
        else {
            PhotoData.snowTemp = Double.nan
        }
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController"))!
        self.present(nextViewController, animated: true)
    }
}
