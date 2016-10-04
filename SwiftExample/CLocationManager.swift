//
//  CLocationManager.swift
//  BA-Clock
//
//  Created by April on 5/5/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//


import Foundation
import CoreLocation
import Alamofire


class CLocationManager: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: CLocationManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            
            static var instance: CLocationManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CLocationManager()
        }
        return Static.instance!
    }
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    var SyncTimer: NSTimer?
    var ResetLocaitonAccurarcyTimer : NSTimer?
    
    var NoComeBackTimer: NSTimer?
    
    var hasfirstTrack = 0
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.activityType = .OtherNavigation
        self.setHighLocationAccurcy()
        
    }
    
    func startUpdatingLocation() {
        
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.setHighLocationAccurcy()
        
        self.locationManager?.startUpdatingLocation()
        
      
    }
    
    func setHighLocationAccurcy() {
        self.locationManager?.distanceFilter = 1
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
   
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName(ChatConstants.LocationServericeChanged, object: nil)
            
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation? = locations.last
        self.currentLocation = location
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){

        manager.startUpdatingLocation()
    
    }
    
    
}
