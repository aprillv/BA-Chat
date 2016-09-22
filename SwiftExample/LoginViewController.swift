//
//  ViewController.swift
//  Chat99
//
//  Created by April on 9/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuth
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var backView: UIView!{
        didSet{
//            backView.layer.cornerRadius = 3
//            backView.layer.borderColor = UIColor.lightGrayColor().CGColor
//            backView.layer.borderWidth = 1.0
            
//            backView.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
//            backView.layer.borderWidth = 0
//            
//            backView.layer.shadowColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
//            backView.layer.shadowOpacity = 1
//            backView.layer.shadowRadius = 1.0
//            backView.layer.shadowOffset = CGSize(width: -1.0, height: 0)
            
            backView.backgroundColor = UIColor.whiteColor()
            backView.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
            backView.layer.cornerRadius = 2.0
            backView.layer.borderWidth = 1.0
            
            backView.layer.shadowColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
            backView.layer.shadowOpacity = 1
            backView.layer.shadowRadius = 3.0
            backView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
            
        }
    }
    @IBOutlet weak var username: UITextField!{
        didSet{
            username.returnKeyType = .Go
            username.enablesReturnKeyAutomatically = true
            username.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        Login(loginBtn)
        return true
    }
    
    @IBOutlet weak var seperateLIne: UIView!{
        didSet{
            seperateLIne.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.layer.cornerRadius = 3.0
        }
    }
    
    var locationManager : CLLocationManager?
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager?.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userlocation = locations.last
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        userlocation = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager?.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager?.startUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        self.username.text = "April Test"
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.NotDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        } else if (authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager?.startUpdatingLocation()
        }   else{
            let winner = UIAlertController(title: "BA-Chat",message: "Please turn on location service with this app in order to use this function.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func Login(sender: AnyObject) {
        if let text = username.text {
            if text != ""{
                getTokenFromServer()
            }
        }
        
    }
    
    private func getTokenFromServer(){
//        let aaa = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjdXN0b21sb2dpbkBiYXNjaGVkdWxpbmctNTRhMTQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJjdXN0b21sb2dpbkBiYXNjaGVkdWxpbmctNTRhMTQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTQ3NDI1MDkyNiwiZXhwIjoxNDc0MjU0NTI2LCJ1aWQiOiJBcHJpbCBUZXN0In0.of4WwDpjJNjvdXTqm2LIENhGTS-4MyG4XxFjIFXLjsUYDA-K6e-9RDHTKu-lyXN4IFKQideIygI123HiDL7VemgmfSU9_YQhNya7jQSTOQiw5JoW7KhZwy0dtJ2hf7jObZMTkWBnKB_9V412bNjDLKwCW2EOK-Wvd6g1TB09ablHpIiEbMd4epCrcLLgHn2VlP3k6Kph81ClpmzwFbmkdLKiUdHh0ME8tQIzNmVvWU-tVhdRnNWNDCwSg_3M5-KAkuwW-3rhcGNmcGho6pLbKadiQlMvfCbomngDB3lFU_hdJvgPMLepwiJNVu-YyC53qU4Q5dyomOX8Ql4w3tA5tA"
        let para=["username": username.text ?? "April Test"];
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Login..."
        Alamofire.request(.GET, "http://sdk.itshapapp.com/getfirebasetoken.json",parameters:para)
            .responseJSON { response in
//                hud.hideAnimated(true)
//                //print(response.request)  // original URL request
//                //print(response.response) // URL response
//                //print(response.data)	 // server data
//                //print(response.result)   // result of response serialization
                 let JSON = response.result.value
        
//                print(JSON?.valueForKey("message"))
                    if let customToken = JSON?.valueForKey("message") as? String{
                        //                        FIRApp.configure()
                        FIRAuth.auth()?.signInWithCustomToken(customToken) { (user, error) in
                            if let user = FIRAuth.auth()?.currentUser {
//                                self.setupFirebase()
                                hud.hideAnimated(true)
//                                let name = user.displayName
//                                let email = user.email
//                                let photoUrl = user.photoURL
//                                let uid = user.uid;  // The user's ID, unique to the Firebase project.
                                self.performSegueWithIdentifier("showMainMap", sender: user)
//                                print(uid)
                                //                                print(uid)
                                // Do NOT use this value to authenticate with
                                // your backend server, if you have one. Use
                                // getTokenWithCompletion:completion: instead.
                            } else {
                                  hud.hideAnimated(true)
                                let alert: UIAlertController = UIAlertController(title: "BA - Chat", message: "Something wrong happened, please try again later", preferredStyle: .Alert)
                                
                                //Create and add the OK action
                                let oKAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {  action -> Void in
                                                                    }
                                alert.addAction(oKAction)
                                
                                
                                //Present the AlertController
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                        
                    }
                
                
        }
        
        
    }
    
    var userlocation : CLLocation?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Chat" {
            if let c = segue.destinationViewController as? Chat2ViewController, let a = sender as? FIRUser {
                c.user = a
//                c.senderId = a.uid ?? "April Test"
//                c.senderDisplayName = a.displayName ?? "April Test"
            }
        }else if segue.identifier == "showMainMap"{
            if let c = segue.destinationViewController as? FBViewController{
                c.userlocation = userlocation
            }
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

