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
    
    var activeTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionalDataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        txtViewComments.delegate = self
        
        txtFieldSnowDepth.addTarget(self, action: #selector(OptionalDataViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        txtFieldSnowWeight.addTarget(self, action: #selector(OptionalDataViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        txtFieldSnowTemp.addTarget(self, action: #selector(OptionalDataViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
   
    // if the user taps outside of the keyboard, dismiss the keyboard
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    // validate incoming characters on the fly as they are typed to prevent invalid entries
    @objc private func textFieldDidChange(textField: UITextField) {
        let input = textField.text
        if let text = input, text.count > 5 { // make sure the text is less than 5 chars
            textField.text = input?.substring(to: (input?.index(before: (input?.endIndex)!))!) // this line removes the last char
        } else if (input?.countInstances(of: "."))! > 1 { // make sure there is only one decimal point
            textField.text = input?.substring(to: (input?.index(before: (input?.endIndex)!))!)
        } else if input?.count != 0 { // make sure that there are no other characters
            let lastChar = input?.substring(from: (input?.index((input?.endIndex)!, offsetBy: -1))!)
            var validChars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."] // digits, decimal pt
            //if input?.count == 1 {
            //    validChars.append("-") // negative sign only allowed as first character
            //}
            if !validChars.contains(lastChar!) {
                textField.text = input?.substring(to: (input?.index(before: (input?.endIndex)!))!)
            }
        }
    }
    
    // save all data to the PhotoData class
    @IBAction func btnNextTapped(_ sender: Any) {
        if txtFieldSnowDepth.text?.count != 0 {
            PhotoData.snowDepth = (txtFieldSnowDepth.text! as NSString).floatValue
        }
        if txtFieldSnowWeight.text?.count != 0 {
            PhotoData.snowDepth = (txtFieldSnowWeight.text! as NSString).floatValue
        }
        if txtFieldSnowTemp.text?.count != 0 {
            PhotoData.snowDepth = (txtFieldSnowTemp.text! as NSString).floatValue
        }
        PhotoData.debrisDescription = txtViewComments.text
    }
}

extension String {
    func countInstances(of stringToFind: String) -> Int {
        var stringToSearch = self
        var count: Int = 0
        while let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive) {
            stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        return count
    }
}
