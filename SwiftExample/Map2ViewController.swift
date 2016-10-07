//
//  Map2ViewController.swift
//  SwiftExample
//
//  Created by LvApril on 9/15/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//


    import UIKit
    import MapKit
    import Alamofire
    

class Map2ViewController: UIViewController, MKMapViewDelegate{
        
//        var delegate : ChatMapViewControllerDelegate?
    
        @IBOutlet var map: MKMapView!{
            didSet{
                map.showsUserLocation = true
            }
        }
        
        var annotation : CustomAnnotation?
    
    var corr : CLLocationCoordinate2D?
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("April") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "April")
        }
//        annotationView?.pinTintColor = UIColor.redColor()
        annotationView?.tintColor = UIColor.redColor()
        annotationView?.animatesDrop = true
        return annotationView
    }
    
    @IBAction func doCanel(sender: AnyObject) {
    
            
            self.dismissViewControllerAnimated(true) {
                
            }
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            if let coor0 = self.corr {
            let r = MKCoordinateRegionMakeWithDistance(coor0,
                                                       1000, 1000)
            self.map.setRegion(r, animated: true)
            let annotation  = CustomAnnotation(coordinate: coor0)
            annotation.coordinate = coor0
            self.map.addAnnotation(annotation)
            }
            
        }
        
    
        
}

