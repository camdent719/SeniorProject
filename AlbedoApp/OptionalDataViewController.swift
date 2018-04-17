//
//  OptionalDataViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 4/1/18.
//

import UIKit

class OptionalDataViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtFieldSnowDepth: UITextField!
    @IBOutlet weak var txtFieldSnowWeight: UITextField!
    @IBOutlet weak var txtFieldSnowTemp: UITextField!
    @IBOutlet weak var txtViewComments: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var errSnowDepth: UIImageView!
    @IBOutlet weak var errSnowWeight: UIImageView!
    @IBOutlet weak var errSnowTemp: UIImageView!    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionalDataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        txtViewComments.delegate = self
        
        errSnowDepth.isHidden = true
        errSnowWeight.isHidden = true
        errSnowTemp.isHidden = true
    }
   
    // if the user taps outside of the keyboard, dismiss the keyboard
    func dismissKeyboard() {
        view.endEditing(true)
        
        let inputSnowDepth = txtFieldSnowDepth.text
        let inputSnowWeight = txtFieldSnowWeight.text
        let inputSnowTemp = txtFieldSnowTemp.text
        let values = [inputSnowDepth, inputSnowWeight, inputSnowTemp]
        
        let pattern = "^[-+]?[0-9]*\\.?[0-9]+$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        var allValid = true
        for (i, v) in values.enumerated() {
            if (v?.isEmpty)! {
                if i == 0 {
                    errSnowDepth.isHidden = true
                } else if i == 1 {
                    errSnowWeight.isHidden = true
                } else { // i == 2
                    errSnowTemp.isHidden = true
                }
                continue // values are optional, so if empty this is valid
            }
            
            let matches = regex.matches(in: v!, options: [], range: NSRange(location: 0, length: (v!.count)))
            if i == 0 {
                if matches.count < 1 {
                    errSnowDepth.isHidden = false
                    allValid = false
                } else {
                    errSnowDepth.isHidden = true
                }
            } else if i == 1 {
                if matches.count < 1 {
                    errSnowWeight.isHidden = false
                    allValid = false
                } else {
                    errSnowWeight.isHidden = true
                }
            } else { // if i == 2
                if matches.count < 1 {
                    errSnowTemp.isHidden = false
                    allValid = false
                } else {
                    errSnowTemp.isHidden = true
                }
            }
        }
        
        if allValid {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    // if the user taps inside the text view, scroll so the text view remains visible
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: txtViewComments.center.y - 100), animated: true)
    }
    
    // when text view editing ends, reset scroll point
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        txtViewComments.resignFirstResponder()
    }
    
    // when Done key on keyboard tapped, dismiss keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    // if the user clicks back, they are retaking the photos. Ask them to confirm if they want to do this
    @IBAction func btnBackTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Retake Photos?", message: "Going back to the previous screen will require you to retake the two photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancelled")
        }))
        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: { action in
            PhotoData.photoDownRGB.removeAll()
            PhotoData.photoUpRGB.removeAll()
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!
            self.present(prevViewController, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // save all data to the PhotoData class
    @IBAction func btnNextTapped(_ sender: Any) {
        if txtFieldSnowDepth.text?.count != 0 {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).floatValue
        }
        if txtFieldSnowWeight.text?.count != 0 {
            PhotoData.snowWeight = (txtFieldSnowWeight.text! as NSString).floatValue
        }
        if txtFieldSnowTemp.text?.count != 0 {
            PhotoData.snowTemp = (txtFieldSnowTemp.text! as NSString).floatValue
        }
        PhotoData.debrisDescription = txtViewComments.text
    }
}
