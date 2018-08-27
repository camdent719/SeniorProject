//
//  NotesViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 8/26/18.
//

import Foundation
import UIKit

class NotesViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var txtViewComments: UITextView!
    
    let debrisPlaceholderText: String = "i.e.: debris on snow, ice surface, footprints, rain-on-snow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionalDataViewController.dismissKeyboard))
        //view.addGestureRecognizer(tap)
        txtViewComments.delegate = self
        
        if PhotoData.debrisDescription.isEmpty {
            // show placeholder
            //txtViewComments.delegate = self
            txtViewComments.text = debrisPlaceholderText
            txtViewComments.textColor = UIColor.lightGray
        }
        else {
            txtViewComments.textColor = UIColor.black
            txtViewComments.text = PhotoData.debrisDescription
        }
    }
    
    // if the user taps outside of the keyboard, dismiss the keyboard
    /*@objc func dismissKeyboard() {
        view.endEditing(true)
    }*/
    
    // if the user taps inside the text view, scroll so the text view remains visible
    func textViewDidBeginEditing(_ textView: UITextView) {
        // used when starting debris description editing
        if txtViewComments.textColor == UIColor.lightGray {
            txtViewComments.text = ""
            txtViewComments.textColor = UIColor.black
        }
    }
    
    // when text view editing ends, reset scroll point
    func textViewDidEndEditing(_ textView: UITextView) {
        // used when stopping debris description editing
        if txtViewComments.text == "" {
            txtViewComments.textColor = UIColor.lightGray
            txtViewComments.text = debrisPlaceholderText
        }
        
        txtViewComments.resignFirstResponder()
    }
    
    // when Done key on keyboard tapped, dismiss keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if txtViewComments.textColor == UIColor.black {
            PhotoData.debrisDescription = txtViewComments.text
        }
        else {
            PhotoData.debrisDescription = ""
        }
        let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "OptionalDataViewController"))!
        self.present(prevViewController, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if txtViewComments.textColor == UIColor.black {
            PhotoData.debrisDescription = txtViewComments.text
        }
        else {
            PhotoData.debrisDescription = ""
        }
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "EndTimeViewController"))!
        self.present(nextViewController, animated: true)
    }
}
