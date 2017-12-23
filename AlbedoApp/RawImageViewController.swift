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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var isCaptureSessionConfigured = false // Instance proprerty on this view controller class
    var captureSession:RawImageCapture = RawImageCapture()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isCaptureSessionConfigured {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        } else {
            // First time: request camera access, configure capture session and start it.
            self.checkCameraAuthorization({ authorized in
                guard authorized else {
                    print("Permission to use camera denied.")
                    return
                }
                captureSession.sessionQueue.async {
                    self.configureCaptureSession({ success in
                        guard success else { return }
                        self.isCaptureSessionConfigured = true
                        self.captureSession.startRunning()
                        DispatchQueue.main.async {
                            self.previewView.updateVideoOrientationForDeviceOrientation()
                        }
                    })
                }
            })
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
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

