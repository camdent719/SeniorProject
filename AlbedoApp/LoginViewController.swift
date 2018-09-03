//
//  LoginViewController.swift
//  AlbedoApp
//
//  Created by Christopher Puda on 9/2/18.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var nextViewName = "HistoryViewController"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityMonitor: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents() // Need if we want the user to not interact with anything until the login process completes
        if (usernameTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Warning", message: "Please enter your username.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                print("cancelled")
            }))
            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        else if (passwordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Warning", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                print("cancelled")
            }))
            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        else {
            self.loginActivityMonitor.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                
                // Let the UI wait for a response
                sleep(1) // i.e. connect to server and login
                
                OperationQueue.main.addOperation() {
                    self.handlePostLogin()
                }
            }
        }
    }
    
    // Let the UI respond to the result
    func handlePostLogin() {
        self.loginActivityMonitor.stopAnimating()
        let failed = self.usernameTextField.text == "fail" // i.e. the cause of a login failure
        if failed {
            // If failed, report error message
            print("failed to login")
            let alert = UIAlertController(title: "Warning", message: "Login failed. Check your credentials and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                print("cancelled")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            // Success!
            print("logged in")
            loggedIn = true
            let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
            self.present(nextViewController, animated: true)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
