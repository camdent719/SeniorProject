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
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionalDataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if !PhotoData.snowDepth.isNaN {
            txtFieldSnowDepth.text = String(PhotoData.snowDepth)
        }
        if !PhotoData.snowWeight.isNaN {
            txtFieldSnowWeight.text = String(PhotoData.snowWeight)
        }
        if !PhotoData.snowTubeTareWeight.isNaN {
            txtFieldSnowTubeTareWeight.text = String(PhotoData.snowTubeTareWeight)
        }
        if !PhotoData.snowTemp.isNaN {
            txtFieldSnowTemp.text = String(PhotoData.snowTemp)
        }
        
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
    
    // if the user clicks back, they are retaking the photos. Ask them to confirm if they want to do this
    @IBAction func btnBackTapped(_ sender: Any) {
        if !(txtFieldSnowDepth.text?.isEmpty)! {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).floatValue
        }
        else {
            PhotoData.snowDepth = Float.nan
        }
        if !(txtFieldSnowWeight.text?.isEmpty)! {
            PhotoData.snowWeight = (txtFieldSnowWeight.text! as NSString).floatValue
        }
        else {
            PhotoData.snowWeight = Float.nan
        }
        if !(txtFieldSnowTubeTareWeight.text?.isEmpty)! {
            PhotoData.snowTubeTareWeight = (txtFieldSnowTubeTareWeight.text! as NSString).floatValue
        }
        else {
            PhotoData.snowTubeTareWeight = Float.nan
        }
        if !(txtFieldSnowTemp.text?.isEmpty)! {
            PhotoData.snowTemp = (txtFieldSnowTemp.text! as NSString).floatValue
        }
        else {
            PhotoData.snowTemp = Float.nan
        }
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!
        self.present(prevViewController, animated: true)
    }
    
    // save all data to the PhotoData class
    @IBAction func btnNextTapped(_ sender: Any) {
        if !(txtFieldSnowDepth.text?.isEmpty)! {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).floatValue
        }
        else {
            PhotoData.snowDepth = Float.nan
        }
        if !(txtFieldSnowWeight.text?.isEmpty)! {
            PhotoData.snowWeight = (txtFieldSnowWeight.text! as NSString).floatValue
        }
        else {
            PhotoData.snowWeight = Float.nan
        }
        if !(txtFieldSnowTubeTareWeight.text?.isEmpty)! {
            PhotoData.snowTubeTareWeight = (txtFieldSnowTubeTareWeight.text! as NSString).floatValue
        }
        else {
            PhotoData.snowTubeTareWeight = Float.nan
        }
        if !(txtFieldSnowTemp.text?.isEmpty)! {
            PhotoData.snowTemp = (txtFieldSnowTemp.text! as NSString).floatValue
        }
        else {
            PhotoData.snowTemp = Float.nan
        }
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController"))!
        self.present(nextViewController, animated: true)
    }
}
