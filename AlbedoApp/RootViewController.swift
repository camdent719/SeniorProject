//
//  RootViewController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/18/17.
//
//  GPS Location code adapted from
//  https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//

import UIKit

class RootViewController: UIViewController {
    
    internal static var picturesTaken = false
    private let takePicturesViewName = "GroundCameraViewController"
    private let skipPicturesViewName = "OptionalDataViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnReadyTapped(_ sender: Any) {
        if RootViewController.picturesTaken {
            // Let the user choose to retake pictures
            let alert = UIAlertController(title: "Retake Pictures?", message: "Would you like to retake the pictures?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: { action in
                PhotoData.photoDownRGB.removeAll()
                PhotoData.photoUpRGB.removeAll()
                let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: self.takePicturesViewName))!
                self.present(nextViewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: { action in
                let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: self.skipPicturesViewName))!
                self.present(nextViewController, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: self.skipPicturesViewName))! // Change later to takePicturesViewName
            self.present(nextViewController, animated: true)
            RootViewController.picturesTaken = true
        }
    }
}
