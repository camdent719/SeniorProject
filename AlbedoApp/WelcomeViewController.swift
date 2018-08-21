//
//  WelcomeViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 4/4/18.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var btnBegin: UIButton!
    
    // This array contains string representations of different iPhone models. This app will not work on any iPhone that is older
    // than 6S because these devices lack raw image capture capabilities. The device codes conform to the following key:
    //   "iPhone1,1" = iPhone
    //   "iPhone1,2" = iPhone 3G
    //   "iPhone2,1" = iPhone 3GS
    //   "iPhone3,1" = iPhone 4 (GSM)
    //   "iPhone3,3" = iPhone 4 (CDMA/Verizon/Sprint)
    //   "iPhone4,1" = iPhone 4S
    //   "iPhone5,1" = iPhone 5 (model A1428, AT&T/Canada)
    //   "iPhone5,2" = iPhone 5 (model A1429, everything else)
    //   "iPhone5,3" = iPhone 5c (model A1456, A1532 | GSM)
    //   "iPhone5,4" = iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
    //   "iPhone6,1" = iPhone 5s (model A1433, A1533 | GSM)
    //   "iPhone6,2" = iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
    //   "iPhone7,1" = iPhone 6 Plus
    //   "iPhone7,2" = iPhone 6
    let invalidDevices: [String] = ["iPhone1,1", "iPhone1,2", "iPhone2,1", "iPhone3,1", "iPhone3,3", "iPhone4,1", "iPhone5,1",
                                    "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone7,1", "iPhone7,2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // determine whether or not the device is too old to support this app
        /*var modelName: String { // gets a string representation of this device
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
        
        // Determine validity of given device. If model appears in list of unsupported devices, it's invalid
        func isDeviceInvalid(model: String) -> Bool {
            if invalidDevices.contains(model) {
                return true
            } else {
                return false
            }
        }
        
        if isDeviceInvalid(model: modelName) { // if device invalid, alert user and prevent further action
            let alert = UIAlertController(title: "Your device is unsupported", message: "Albedo app can only run on iPhone 6S or newer due to camera capabilities.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.btnBegin.isEnabled = false
            }))
            self.present(alert, animated: true, completion: nil)
        }*/
    }
}
