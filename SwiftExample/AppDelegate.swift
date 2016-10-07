//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/8/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import Alamofire
import Firebase
import FirebaseAuth


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager:CLLocationManager?
    
    var window: UIWindow?
    
   
    

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        getAllFp1()
        FIRApp.configure()
        
        return true
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        application.statusBarStyle = .LightContent
//        return true
        
        
        if let un = NSUserDefaults.standardUserDefaults().valueForKey(ChatConstants.FBUserName) as? String,
            let uid = NSUserDefaults.standardUserDefaults().valueForKey(ChatConstants.FBUserId) as? String {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: ChatConstants.FBAuthed)
            self.getTokenFromServer(un, phoneNo: uid)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav0 = storyboard.instantiateViewControllerWithIdentifier("nav1") as! UINavigationController
            if let window = self.window {
                window.rootViewController = nav0
                nav0.navigationBar.translucent = false
            }
        }else{
            application.statusBarStyle = .LightContent
            
        }
        return true
    }
    
    
    private func getTokenFromServer(username: String, phoneNo: String){
        let para=["phoneNumber": phoneNo, "username": username];
        //let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
       // hud.label.text = "Login..."
        Alamofire.request(.GET, ChatConstants.ServiceURL + ChatConstants.GetFirebaseTokenSeviceURL,parameters:para)
            .responseJSON { response in
                let JSON = response.result.value
                if let customToken = JSON?.valueForKey("message") as? String{
                    //                        FIRApp.configure()
                    FIRAuth.auth()?.signInWithCustomToken(customToken) { (user, error) in
                        if let user = FIRAuth.auth()?.currentUser {
                            if user.uid == phoneNo {
                                NSUserDefaults.standardUserDefaults().setInteger(1, forKey: ChatConstants.FBAuthed)
                            }
                        }
                    }
                    
                }
                
                
        }
        
        
    }
    
    
        func getAllFp1() {
            let cl = cl_coreData()
            let fp2 = cl.getFeedplace1()
            if fp2?.count ?? 0 == 0 {
                Alamofire.request(.GET, "http://sdk.itshapapp.com/dbgetworld.json",parameters:nil)
                    .responseJSON { response in
                        
                        let JSON = response.result.value
    
                        if let fpls = JSON?.valueForKey("Feedplaces1List") as? [[String: AnyObject]] {
                            var fps : [Feedplaces1] = [Feedplaces1]()
                            for fp0 in fpls {
                                let fp = Feedplaces1(dicInfo: fp0)
                                fps.append(fp)
                            }
    
                            if fps.count > 0 {
                                let cl = cl_coreData()
                                cl.savedFeedplace1ToDB(fps)
                            }
                        }
                }
            }
            
        }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

   

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ba.BA_Clock" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BAChat", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        let c = UIApplication.sharedApplication().keyWindow?.rootViewController
        if let a = c?.presentedViewController as? UIAlertController {
            if a.message == "Please turn on location service with this app in order to use this function." {
                let status = CLLocationManager.authorizationStatus()
                if status == .AuthorizedAlways{
                    c?.dismissViewControllerAnimated(true){}
                }
            }
            
        }
    }
    
    


}

