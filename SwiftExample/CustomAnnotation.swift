//
//  CustomAnnotation.swift
//  SwiftExample
//
//  Created by LvApril on 9/13/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String? = ""
    var subtitle: String? = ""
    var index : Int?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
