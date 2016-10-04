//
//  File.swift
//  BAChat
//
//  Created by April on 10/4/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import Foundation

class Util {
    //POLYGON ((-95.4087076759796 29.7150782305219, -95.408837770976 29.7153324524061, -95.409073568157 29.7153324524061, -95.409073568157 29.7154030694819, -95.4088215091014 29.7154242545949, -95.408545057234 29.715537241789, -95.4083824384885 29.7158267708934, -95.4083580456766 29.7168648317938, -95.4085531881713 29.7171190491535, -95.4088784256624 29.7172602807418, -95.4091711394044 29.7172602807418, -95.4091630084671 29.7172814654629, -95.409276841589 29.7172814654629, -95.409276841589 29.7173238348917, -95.409378599846 29.7173299763151, -95.4093739782724 29.7172911767076, -95.4095234091529 29.717288500872, -95.4095203281038 29.7172617425125, -95.4098700271747 29.7172630804306, -95.4101873752303 29.7171145714079, -95.4103632295484 29.7168465493832, -95.4103582562469 29.7158126475419, -95.4101793756268 29.7155160566998, -95.4098216143865 29.7153818843643, -95.4095939481428 29.7154101311867, -95.4095858172055 29.7153253906958, -95.4097728287629 29.715318328985, -95.4097646978256 29.7151841563852, -95.4090166515961 29.7151841563852, -95.4087076759796 29.7150782305219))
    func isInPolygon(currentLocation: CLLocationCoordinate2D, polygon: String) -> Bool {
//        let polygon = MKPolygon()
//        let mapRect = MKMapRectMake(point.x, point.y, 0.0001, 0.0001)
        let path = UIBezierPath()
        
        let tmp = polygon.stringByReplacingOccurrencesOfString("POLYGON ((", withString: "")
            .stringByReplacingOccurrencesOfString("))", withString: "")
        var hasfirst = false
         let pointarray = tmp.componentsSeparatedByString(", ")
            for point in pointarray {
                let pointTT = point.componentsSeparatedByString(" ")
                    if !hasfirst {
                        hasfirst = true
                        path.moveToPoint(CGPointMake(CGFloat(NSNumberFormatter().numberFromString(pointTT[0]) ?? 0) + 180
                            , CGFloat(NSNumberFormatter().numberFromString(pointTT[1]) ?? 0) + 180))
                    }else{
                        path.addLineToPoint(CGPointMake(CGFloat(NSNumberFormatter().numberFromString(pointTT[0]) ?? 0) + 180
                            , CGFloat(NSNumberFormatter().numberFromString(pointTT[1]) ?? 0) + 180))
                    }
            }
        if hasfirst {
            path.closePath()
//            print(path)
//            print(CGFloat(currentLocation.longitude) + 180, CGFloat(currentLocation.latitude)+180)
//            print(path.containsPoint(CGPointMake(CGFloat(currentLocation.longitude) + 180, CGFloat(currentLocation.latitude)+180)))
            return path.containsPoint(CGPointMake(CGFloat(currentLocation.longitude) + 180, CGFloat(currentLocation.latitude)+180))
        }
        return false
    }
}
