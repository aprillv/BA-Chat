//
//  ProfileViewController.swift
//  BAChat
//
//  Created by April on 9/29/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func goback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var username: UILabel!
    @IBOutlet var phonenumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.text = NSUserDefaults.standardUserDefaults().stringForKey(ChatConstants.FBUserName)
//        if let phone = NSUserDefaults.standardUserDefaults().stringForKey(ChatConstants.FBUserId){
//            let s = "05554446677"
//            let s2 = String(format: "(%@) %@ %@",
//                            s.substringWithRange(s.startIndex.advancedBy(0) ... s.startIndex.advancedBy(3)),
//                            s.substringWithRange(s.startIndex.advancedBy(4) ... s.startIndex.advancedBy(6)),
//                            s.substringWithRange(s.startIndex.advancedBy(7) ... s.startIndex.advancedBy(8)),
//                            s.substringWithRange(s.startIndex.advancedBy(9) ... s.startIndex.advancedBy(10))
//            )
//            
//            phone = 
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
