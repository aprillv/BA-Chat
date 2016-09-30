//
//  Verify0ViewController.swift
//  BAChat
//
//  Created by April on 9/28/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class Verify0ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var logoToTop: NSLayoutConstraint!
    
    @IBOutlet var logo: UIImageView!
    
    @IBOutlet var backviewToLogo: NSLayoutConstraint!
    
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
    @IBOutlet weak var username: UITextField!{
        didSet{
            username.returnKeyType = .Next
            username.keyboardType = .NamePhonePad
            username.enablesReturnKeyAutomatically = true
            username.delegate = self
        }
    }
    
    @IBOutlet var phonenotxt: UITextField!{
        didSet{
            phonenotxt.delegate = self
            phonenotxt.placeholder = "888-888-8888"
        }
    }
    @IBOutlet var line3: UIView!{
        didSet{
            self.setLineColor(line3)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        Login(loginBtn)
        if textField == username {
            phonenotxt.becomeFirstResponder()
        }
        return true
    }
    @IBOutlet var sepeline: UIView!{
        didSet{
//            self.setLineColor(sepeline)
        }
    }
    
    @IBOutlet var line2: UIView!{
        didSet{
            self.setLineColor(line2)
        }
    }
    @IBOutlet weak var seperateLIne: UIView!{
        didSet{
            self.setLineColor(seperateLIne)
        }
    }
    
    private func setLineColor(line : UIView){
        line.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
    }
    
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.layer.cornerRadius = 3.0
        }
    }
    @IBAction func GoSendVerifyCode(sender: UIButton) {
        
        if username.text == nil || username.text == ""{
            
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input your name",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.username.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }else if phonenotxt.text == nil || phonenotxt.text == ""{
            
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input your phone No.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.phonenotxt.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }else if !validateNum(self.phonenotxt.text!) {
            let winner = UIAlertController(title: "HapApp-Chat",message: "Please input an valid phone No.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                self.phonenotxt.becomeFirstResponder()
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
            
        }else{
            if let text = phonenotxt.text?.stringByReplacingOccurrencesOfString("-", withString: ""){
                username.resignFirstResponder()
                phonenotxt.resignFirstResponder()
                getVerifyCodeFromServer(text)
            }
            
        }

    }
    
    func validateNum(value: String) -> Bool {
//         return true
        if value.characters.count == 12 {
            return true
        }
        
        return false
        //        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //        let result =  phoneTest.evaluateWithObject(value)
        //        return result
    }
    
    private struct Constants{
        static let SegueToLoginPage = "GoToLoginPage"
        
    }

    
    private func getVerifyCodeFromServer(phone : String){
        
//        var para = ["phoneNumber": "1" + phone]
//        if phone == "9999999999" || phone == "8888888888" || phone == "7777777777" {
//            para = ["phoneNumber": phone]
//        }
        let para = ["phoneNumber": phone]
//        if username.text!.lowercaseString.hasPrefix("april"){
//            para = ["phoneNumber": "8613386463196"]
//        }
//        let para = ["phoneNumber": "8613386463196"]
//        print(para)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Sending Verification Code..."
        Alamofire.request(.GET
            , ChatConstants.ServiceURL + ChatConstants.QueryVerifyCode
            ,parameters:para)
            .responseJSON { response in
                hud.hideAnimated(true)
                
                if let JSON = response.result.value as? [String: AnyObject]{
                    //                    print(response.result.value)
//                    print("code == " + (JSON["verifyCode"]! as! String))
                    
                    if let _ = JSON["phoneNumber"] {
                        self.performSegueWithIdentifier(Constants.SegueToLoginPage, sender: nil)
                    }else{
                        let alert: UIAlertController = UIAlertController(title: "BA - Chat", message: "Verify code sent failed, please check your phone number or try again later.", preferredStyle: .Alert)
                        
                        //Create and add the OK action
                        let oKAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {  action -> Void in
//                            self.enableBtn()
                        }
                        alert.addAction(oKAction)
                        
                        
                        //Present the AlertController
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueToLoginPage {
            if let c = segue.destinationViewController as? LoginViewController{
                let phone = self.phonenotxt.text!.stringByReplacingOccurrencesOfString("-", withString: "")
                c.phoneNo = phone
//                if phone == "9999999999" || phone == "8888888888" || phone == "7777777777" {
//                    c.phoneNo = self.phonenotxt.text!
//                }else{
//                    c.phoneNo = "1" + self.phonenotxt.text!
//                }
                
                
                c.username = self.username.text
            }
        }

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phonenotxt
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString.stringByRemovingPercentEncoding
            return false
        }
        else
        {
            return true
        }
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.navigationBar.translucent = false
        
        if self.view.frame.width < 321 {
            self.logoToTop.constant = 0
            self.logo.hidden = true
            self.backviewToLogo.constant = 0
            self.view.updateConstraintsIfNeeded()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
