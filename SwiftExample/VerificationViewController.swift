//
//  VerificationViewController.swift
//  BAChat
//
//  Created by April on 9/27/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuth
import MBProgressHUD

class VerificationViewController: UIViewController {

    @IBOutlet weak var backView: UIView!{
        didSet{
            
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
    
    @IBOutlet var TelephoneNo: UITextField!{
        didSet{
            TelephoneNo.returnKeyType = .Go
            TelephoneNo.keyboardType = .PhonePad
            TelephoneNo.enablesReturnKeyAutomatically = true
            //TelephoneNo.delegate = self
            
        }
    }
    @IBOutlet var line3: UIView!{
        didSet{
            self.setLineColor(line3)
        }
    }
    @IBOutlet var verifyCodeTxt: UITextField!{
        didSet{
            verifyCodeTxt.returnKeyType = .Go
            verifyCodeTxt.keyboardType = .NumberPad
            verifyCodeTxt.enablesReturnKeyAutomatically = true
           // verifyCodeTxt.delegate = self
            
        }
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        Login(loginBtn)
//        return true
//    }
    
    @IBOutlet var line2: UIView!{
        didSet{
            self.setLineColor(line2)
        }
    }
    
    private func setLineColor(line : UIView){
        line.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
    }
    
    @IBOutlet var sendVerifycodeBtn: UIButton!{
        didSet{
            sendVerifycodeBtn.layer.cornerRadius = 3.0
        }
    }
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.layer.cornerRadius = 3.0
        }
    }
    
    @IBAction func DoLogin0(sender: UIButton) {
        if self.verifyCodeTxt.text == nil || self.verifyCodeTxt.text == "" {
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input Verify Code.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.TelephoneNo.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }else{
            self.VerifyCodeWithServer()
        }
        
    }
    @IBAction func SendVerifyCode(sender: AnyObject) {
        if TelephoneNo.text == nil || TelephoneNo.text == ""{
            
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input your Telephone No.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.TelephoneNo.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }else if !validateNum(self.TelephoneNo.text!) {
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input an valid Telephone No.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.TelephoneNo.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
            
        }else{
            self.sendVerifycodeBtn.enabled = false
            self.sendVerifycodeBtn.backgroundColor = UIColor(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
//            timer = NSTimer.scheduledTimerWithTimeInterval(90, target: self, selector: Selector(self.enableBtn()), userInfo: nil, repeats: false)
            let cc = dispatch_time(DISPATCH_TIME_NOW, Int64(60 * NSEC_PER_SEC))
                dispatch_after(cc, dispatch_get_main_queue(), {
                    self.sendVerifycodeBtn.enabled = true
                    self.sendVerifycodeBtn.backgroundColor = self.loginBtn.backgroundColor

                })
//            self.performSelector(Selector(self.enableBtn()), withObject: 1, afterDelay: 90)
            getVerifyCodeFromServer()
        }
    }

//    var timer : NSTimer?
    
    func enableBtn() {
        self.sendVerifycodeBtn.enabled = true
        self.sendVerifycodeBtn.backgroundColor = self.loginBtn.backgroundColor
    }
    private func getVerifyCodeFromServer(){
        let para = ["phoneNumber": TelephoneNo.text ?? ""]
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Sending Verification Code..."
        Alamofire.request(.GET
            , ChatConstants.ServiceURL + ChatConstants.QueryVerifyCode
            ,parameters:para)
            .responseJSON { response in
                hud.hideAnimated(true)
                if let JSON = response.result.value as? [String: AnyObject]{
                    //                    print(response.result.value)
                    print(JSON["verifyCode"])
                    
                    if let _ = JSON["phoneNumber"] {
//                        self.firstColor = self.sendVerifycodeBtn.backgroundColor
                        
                        
//                        NSTimer.scheduledTimerWithTimeInterval(90, target: self, selector: Selector(self.enableBtn()), userInfo: nil, repeats: false)
//                        self.verifyCodeTxt.text = JSON["verifyCode"] as? String
//                        
//                        
//                        
//                        self.verifyCodeTxt.hidden = false
//                        self.line3.hidden = false
//                        self.backViewHeight.constant = Constants.BackViewHeightSecond
//                        //                    UIView.animateWithDuration(10){
//                        //                    self.view.updateConstraints()
//                        //                    }
//                        self.username.userInteractionEnabled = false
//                        self.TelephoneNo.userInteractionEnabled = false
//                        self.loginBtn.setTitle(Constants.Login, forState: .Normal)
//                        self.loginBtn.setTitle(Constants.Login, forState: .Highlighted)
//                        self.view.updateConstraints()
                    }else{
                        let alert: UIAlertController = UIAlertController(title: "BA - Chat", message: "Verify code sent failed, please check your phone number or try again later.", preferredStyle: .Alert)
                        
                        //Create and add the OK action
                        let oKAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {  action -> Void in
                            self.enableBtn()
                        }
                        alert.addAction(oKAction)
                        
                        
                        //Present the AlertController
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
        }
    }
    
    private struct Constants{
        static let SegueToLoginPage = "GoToLoginPage"
        
    }
    
//    var firstColor : UIColor?
    
    private func VerifyCodeWithServer(){
        let para = ["phoneNumber":self.TelephoneNo.text!, "verifyCode": self.verifyCodeTxt.text!]
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Validating..."
        
        
        
        Alamofire.request(.GET
            , ChatConstants.ServiceURL + ChatConstants.VerifyCodeWithSeviceURL
            ,parameters:para)
            .responseJSON { response in
                hud.hideAnimated(true)
//                print(response.result.value)
                if let JSON = response.result.value as? [String: AnyObject]{
                    
                    if (JSON["verified"] as? NSInteger ?? 0) == 1 {
                        
                        self.performSegueWithIdentifier(Constants.SegueToLoginPage, sender: nil)
                    }else{
                        let alert: UIAlertController = UIAlertController(title: "BA - Chat", message: "Verify code is not correct.", preferredStyle: .Alert)
                        
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
    
    func validateNum(value: String) -> Bool {
        if value.characters.count == 11 {
            return true
        }
        
        return false
        //        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //        let result =  phoneTest.evaluateWithObject(value)
        //        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueToLoginPage {
            if let c = segue.destinationViewController as? LoginViewController{
                c.phoneNo = self.TelephoneNo.text
            }
        }
    }
    
}
