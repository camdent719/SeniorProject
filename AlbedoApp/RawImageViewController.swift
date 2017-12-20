//
//  RawImageViewController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/19/17.
//

import UIKit
import AVFoundation // needed for functions related to the camera

class RawImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkCameraAuthorization { authorized in
            if authorized {
                // Proceed to set up and use the camera.
            } else {
                print("Permission to use camera denied. Camera permission must be granted in order to use Albedo App.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // checks to see if camera usage has been authorized and prompts user if it is not
    func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { success in
                completionHandler(success)
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
        }
    }
}

