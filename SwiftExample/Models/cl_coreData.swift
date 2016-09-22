//
//  cl_clockData.swift
//  BA-Clock
//
//  Created by April on 1/20/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class cl_coreData: NSObject {
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
//    func savedScheduledDaysToDB(itemList : [ScheduledDayItem]){
//        return
//        let fetchRequest = NSFetchRequest(entityName: "ScheduledDay")
//        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try persistentStoreCoordinator.executeRequest(request, withContext: managedObjectContext)
//            for item : ScheduledDayItem in itemList {
//                let entity =  NSEntityDescription.entityForName("ScheduledDay",
//                    inManagedObjectContext:managedObjectContext)
//                
//                let scheduledDayItem = NSManagedObject(entity: entity!,
//                    insertIntoManagedObjectContext: managedObjectContext)
//                
//                
//                
//                scheduledDayItem.setValue(item.ClockIn!, forKey: "clockIn")
//                scheduledDayItem.setValue(item.ClockInCoordinate!.Latitude!, forKey: "clockInLatitude")
//                scheduledDayItem.setValue(item.ClockInCoordinate!.Longitude!, forKey: "clockInLongitude")
//                scheduledDayItem.setValue(item.ClockInDay!, forKey: "clockInDay")
//                scheduledDayItem.setValue(item.ClockInDayFullName!, forKey: "ClockInDayFullName")
//                scheduledDayItem.setValue(item.ClockInDayName!, forKey: "ClockInDayName")
//                scheduledDayItem.setValue(item.ClockInDayOfWeek!, forKey: "ClockInDayOfWeek")
//                scheduledDayItem.setValue(item.ClockOut!, forKey: "clockOut")
//                scheduledDayItem.setValue(item.ClockOutCoordinate!.Latitude!, forKey: "clockOutLatitude")
//                scheduledDayItem.setValue(item.ClockOutCoordinate!.Longitude!, forKey: "clockOutLatitude")
//                scheduledDayItem.setValue(item.ClockOutDay!, forKey: "ClockOutDay")
//                scheduledDayItem.setValue(item.ClockOutDayFullName!, forKey: "ClockOutDayFullName")
//                scheduledDayItem.setValue(item.ClockOutDayName!, forKey: "ClockOutDayName")
//                scheduledDayItem.setValue(item.ClockOutDayOfWeek!, forKey: "ClockOutDayOfWeek")
//                scheduledDayItem.setValue(item.Hours!, forKey: "Hours")
//                
//                
//                do {
//                    try managedObjectContext.save()
//                    
//                } catch let error as NSError  {
//                    print0000("Could not save \(error), \(error.userInfo)")
//                }
//            }
//            
//        } catch let error as NSError {
//            print0000("\(error)")
//            // TODO: handle the error
//        }
//        
//    
//
//    }
    
    func savedFeedplace1ToDB(itemList : [Feedplaces1]){
        
        let fetchRequest = NSFetchRequest(entityName: "FP1")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentStoreCoordinator.executeRequest(request, withContext: managedObjectContext)
            for item : Feedplaces1 in itemList {
                let entity =  NSEntityDescription.entityForName("FP1",
                    inManagedObjectContext:managedObjectContext)
                
                let scheduledDayItem = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedObjectContext)
                
                scheduledDayItem.setValue(NSInteger(item.idfeedplaces1!.intValue), forKey: "idfeedplaces1")
                scheduledDayItem.setValue(NSInteger(item.chatcount?.intValue ?? 0), forKey: "chatcount")
                scheduledDayItem.setValue(item.placename!, forKey: "placename")
                scheduledDayItem.setValue(Double(item.latitude!.doubleValue), forKey: "latitude")
                scheduledDayItem.setValue(Double(item.longitude!.doubleValue), forKey: "longitude")
                scheduledDayItem.setValue(Double(item.pn!.doubleValue), forKey: "pn")
                scheduledDayItem.setValue(Double(item.ps!.doubleValue), forKey: "ps")
                scheduledDayItem.setValue(Double(item.pw!.doubleValue), forKey: "pw")
                scheduledDayItem.setValue(Double(item.pe!.doubleValue), forKey: "pe")
                do {
                    try managedObjectContext.save()
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
//            print0000("\(error)")
            // TODO: handle the error
        }
        
        
        
    }
    
    func getFeedplace1() -> [Feedplaces1]?{
        let fetchRequest = NSFetchRequest(entityName: "FP1")
//        let predicate = NSPredicate(format: "dayFullName = %@", weekdayNm)
//        fetchRequest.predicate = predicate
        
        //3
        var a = [Feedplaces1]()
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest)
            if let t = results as? [NSManagedObject] {
                for item in t {
                    let tmp : Feedplaces1 = Feedplaces1(dicInfo : nil)
                    tmp.idfeedplaces1 = item.valueForKey("idfeedplaces1") as? NSInteger
                    tmp.placename = item.valueForKey("placename") as? String
                    tmp.chatcount = item.valueForKey("chatcount") as? NSInteger
                    tmp.latitude = item.valueForKey("latitude") as? Double
                    tmp.longitude = item.valueForKey("longitude") as? Double
                    tmp.pn = item.valueForKey("pn") as? Double
                    tmp.ps = item.valueForKey("ps") as? Double
                    tmp.pw = item.valueForKey("pw") as? Double
                    tmp.pe = item.valueForKey("pe") as? Double
                    a.append(tmp)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return a
    
    }
    
    func getIdFeedplace1By(lat: Double, lng : Double) -> Feedplaces1?{
        let fetchRequest = NSFetchRequest(entityName: "FP1")
                let predicate = NSPredicate(format: "ps < \(lat) and pn > \(lat) and pe > \(lng) and pw < \(lng)")
                fetchRequest.predicate = predicate
        
        //3
        var a : Feedplaces1?
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
            if let t = results as? [NSManagedObject] {
            
                if let item = t.first {
                    let tmp : Feedplaces1 = Feedplaces1(dicInfo : nil)
                    tmp.idfeedplaces1 = item.valueForKey("idfeedplaces1") as? NSInteger
                    tmp.placename = item.valueForKey("placename") as? String
                    tmp.chatcount = item.valueForKey("chatcount") as? NSInteger
                    tmp.latitude = item.valueForKey("latitude") as? Double
                    tmp.longitude = item.valueForKey("longitude") as? Double
                    tmp.pn = item.valueForKey("pn") as? Double
                    tmp.ps = item.valueForKey("ps") as? Double
                    tmp.pw = item.valueForKey("pw") as? Double
                    tmp.pe = item.valueForKey("pe") as? Double
                    a = tmp
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return a
        
    }
    
    func getIdFeedplace1lsBy(pn: Double, ps : Double, pw: Double, pe: Double) -> Bool{
        print(pn, ps, pw, pe)
        let fetchRequest = NSFetchRequest(entityName: "FP1")
        let predicate = NSPredicate(format: "(latitude < \(pn)) and (latitude > \(ps)) and (longitude > \(pw)) and (longitude < \(pe))")
        fetchRequest.predicate = predicate
        
        //3
//        var a : Feedplaces1?
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
            if let t = results as? [NSManagedObject] {
                print(t.count)
                if t.count ?? 0 > 1 {
                    return true
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
        
    }
    
    
    
//    func getAllFrequency() -> [FrequencyItem]{
//        let fetchRequest = NSFetchRequest(entityName: "Frequency")
////        let predicate = NSPredicate(format: "dayFullName = %@", weekdayNm)
////        fetchRequest.predicate = predicate
//        
//        var rtn = [FrequencyItem]()
//        //3
//        do {
//            let results =
//                try managedObjectContext.executeFetchRequest(fetchRequest)
//            if let t = results as? [NSManagedObject] {
//                for item in t {
//                    let tmp : FrequencyItem = FrequencyItem(dicInfo : nil)
//                    tmp.DayFullName = item.valueForKey("dayFullName") as? String
//                    tmp.DayOfWeek = item.valueForKey("dayOfWeek") as? NSNumber
//                    tmp.DayName = item.valueForKey("dayName") as? String
//                    tmp.ScheduledFrom = item.valueForKey("scheduledFrom") as? String
//                    tmp.ScheduledInterval = item.valueForKey("scheduledInterval") as? NSNumber
//                    tmp.ScheduledTo = item.valueForKey("scheduledTo") as? String
//                    rtn.append(tmp)
//                }
//            }
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return rtn
//        
//    }
    
}
