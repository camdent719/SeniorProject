//  AlbedoApp
//  LoginViewController.swift
//  Created by Christopher Puda on 9/2/18.
//  Take it over by Haoxuan Jiang on 10/2/18

import UIKit

class LoginViewController: UIViewController {
    
    private var nextViewName = "HistoryViewController"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityMonitor: UIActivityIndicatorView!
    //A string array to save all the names for get request below
    var nameArray = [String]()

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
        //post add 10.10 below
        //post username & password as NSDictionary through JSON format

        //prepare json data
        let username: String = usernameTextField.text!
        let password: String = passwordTextField.text!

        let json: [String: Any] = ["username": "CoCoRAHS5",
                                   "password": "A1b3d02011!"]
//        let json: [String: Any] = ["username": username,
//                                   "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://albedo.gsscdev.com/api/auth/get_token/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        /*post a json not a string  swift json
        //give me back another json
         output from server  --- token
         */
        // insert json data to the request
        request.httpBody = jsonData
        print("------------------------------------------------json successful enter~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
               // print("response = \(response)")
            }
         
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            //----------------------------------------------------------------------------
            //call getrequest to show
                 self.getRequest(rawurl:  "http://albedo.gsscdev.com/api/users/")
            }
        }
        task.resume()
        
        //below am i already logged in
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
    
    func getRequest(rawurl:String) {
        //creating a NSURL
        let url2 = URL(string: rawurl)
        //fetching the data from the url
        var urlRequest = URLRequest(url: url2!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token 8d0996bc46f6d1bb47795ee70fc74d8c226e2ea1", forHTTPHeaderField: "Authorization") //make flexiable
        urlRequest.httpMethod = "GET"
        
          URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
             if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                //printing the json in console
                print(jsonObj!.value(forKey: "results")!)
                print(jsonObj!.value(forKey: "next")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let heroeArray = jsonObj!.value(forKey: "results") as? NSArray {
                    //looping through all the elements
                    for heroe in heroeArray{
                        //converting the element to a dictionary
                        if let heroeDict = heroe as? NSDictionary {
                            //getting the name from the dictionary
                            if let name = heroeDict.value(forKey: "username") {
                                //adding the name to the array
                                let sname = name as? String
                                self.nameArray.append((name as? String)!)
                                 //---------------------------------------------------------
                                 print(sname!)
                                
                                 if(sname == "CATHLEENDawson")
                                 {
                                    //test to find
                                    print("--------------type whatever id i want 1--------------")
                                    if ( self.nameArray.contains(sname!) )
                                    {
                                        //test contain works
                                        print("e-------------nter successfully 2!!------------------")
                                        let id = heroeDict.value(forKey: "id") as? Int
                                        //ID found
                                        print("Find ID: " , id as! Int)
                                    
                                    
                                        //after finding, do post in here
                                    }
                                 }
                                
                            }
                        }
                    }
                }
                //recursion ！！！！
                let nextURL = jsonObj!.value(forKey: "next")!
                if(!(nextURL is NSNull)){
                    self.getRequest(rawurl:nextURL as! String)
                }
                else
                {
                    print("Done, no more pages")
                }
                
            }
           /*  else
                print("jsonObj TEST")
        */
        }).resume()
    }
    
    /*
    struct DataEntry {
        var user: field
        var station_Number: String
        var observation_Date: Date
        var observation_Time: time_t
        var end_Albedo_Observation_time: time_t
        var cloud_Coverage: choice
        var incoming_Shortwave_1: float_t
        var incoming_Shortwave_2: float_t
        var incoming_Shortwave_3: float_t
        var outgoing_Shortwave_1: float_t
        var outgoing_Shortwave_2: float_t
        var outgoing_Shortwave_3: float_t
        var surface_Skin_Temperature: String
        var tube_Number: Int
        var snowfall_Last_24hours: choice
        var snow_Melt: choice
        var snow_state: choice
        var patchiness: choice
        var snow_surface_age: choice
        var ground_cover: choice
    }
 */
}

