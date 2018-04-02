//
//  OptionalDataViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 4/1/18.
//

import UIKit

class OptionalDataViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtViewComments: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
        scrollView.contentOffset = CGPoint(x: 0, y: txtViewComments.center.y - 100)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
    }
}
