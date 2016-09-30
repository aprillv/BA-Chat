//
//  ChatConstants.swift
//  BAChat
//
//  Created by April on 9/27/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import Foundation

struct ChatConstants{
    static let ServiceURL = "http://sdk.itshapapp.com/"
    static let QueryVerifyCode = "getVerifyCode.json" //{"phoneNumber":"String"}
    
    static let VerifyCodeWithSeviceURL = "verifyPhoneNumber.json"  //{"phoneNumber":"String","verifyCode":"String"}
    
    static let GetFirebaseTokenSeviceURL = "getfirebasetoken.json"
    
    
    static let FBUserId = "FBUER_ID"
    static let FBUserName = "FBUsername"
    static let FBAuthed = "FBAuthed"
    
    static let AppColor = UIColor(red: 246/255.0, green: 99/255.0, blue: 115/255.0, alpha: 1)
    static let AppColorWithAlpha = UIColor(red: 246/255.0, green: 99/255.0, blue: 115/255.0, alpha: 0.5)
    
    static let GoogleApiKey = "AIzaSyAyW0Xj8Q8m9-FJ2aSibTcYKPBqC1aiFHo"
    
    static let PostRadius = 100
    
}
