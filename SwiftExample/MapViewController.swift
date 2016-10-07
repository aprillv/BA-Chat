//
//  MapViewController.swift
//  SwiftExample
//
//  Created by April on 9/12/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

protocol ChatMapViewControllerDelegate {
    func sendLocationS(l: CLLocationCoordinate2D, address: String?)
}
class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate{

    var delegate : ChatMapViewControllerDelegate?
    
    @IBOutlet var map: MKMapView!{
        didSet{
            map.showsUserLocation = true
        }
    }
    
    var annotation : CustomAnnotation?
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        if let l = userLocation.location{
//            mapView.setCenterCoordinate(l.coordinate, animated: true)
            let region = MKCoordinateRegionMakeWithDistance(l.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
//            https://maps.googleapis.com/maps/api/geocode/json?&address=37.33233141%20-122.0312186
//            https://maps.googleapis.com/maps/api/geocode/json?&address=29.724646%20-95.400176
            
             annotation  = CustomAnnotation(coordinate: l.coordinate)
            annotation?.coordinate = l.coordinate
            mapView.addAnnotation(annotation!)
            
            Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json?&address=\(l.coordinate.latitude)%20\(l.coordinate.longitude)", parameters:nil)
                .responseJSON { response in
                    let JSON1 = response.result.value
                    if let JSON = JSON1?.valueForKey("results") as? [AnyObject] {
                        self.db = JSON
                        self.tableview.reloadData()
                        let path = NSIndexPath(forRow: 0, inSection: 0)
                        self.tableview.selectRowAtIndexPath(path, animated: true, scrollPosition: .Top)
                        self.tableView(self.tableview, didSelectRowAtIndexPath: path)
                        return
                        
                    }
            
            }
        }
        
        
    }
    @IBAction func sendL(sender: AnyObject) {
      
        self.dismissViewControllerAnimated(true) {
            if self.tableview.indexPathForSelectedRow?.row == 0 {
                let location = self.map.userLocation
                if let del = self.delegate {
                    del.sendLocationS(location.coordinate, address: "")
                }
            }else{
                let js = self.db![(self.tableview.indexPathForSelectedRow?.row ?? 1) - 1]
                if let corr = js.valueForKey("geometry")?.valueForKey("location"){
                    if let lat = corr.valueForKey("lat") as? Double, let lng = corr.valueForKey("lng") as? Double {
                        
                        if let del = self.delegate {
                            del.sendLocationS(CLLocationCoordinate2D(latitude: lat, longitude: lng), address: js.valueForKey("formatted_address") as? String)
                        }
                    }
                }
            }
            
        }
    }
    @IBAction func cancel(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.delegate = self
            tableview.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var db : [AnyObject]?
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (db?.count ?? 0) + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("mapc")!
        if indexPath.row == 0 {
            cell.textLabel?.text = "Current Locaiton"
        }else{
            cell.textLabel?.text = db![indexPath.row-1].valueForKey("formatted_address") as? String ?? ""
        }
        if indexPath != tableview.indexPathForSelectedRow {
            cell.accessoryType = .None
        }else{
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("April") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "April")
        }
        if #available(iOS 9.0, *) {
            annotationView?.pinTintColor = UIColor.redColor()
        } else {
            // Fallback on earlier versions
        }
        annotationView?.animatesDrop = true
        return annotationView
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        if indexPath.row == 0 {
            
            
            self.map.removeAnnotations(self.map.annotations)
            let r = MKCoordinateRegionMakeWithDistance(map.userLocation.coordinate,
                                                       500, 500)
            self.map.setRegion(r, animated: true)
            annotation  = CustomAnnotation(coordinate: map.userLocation.coordinate)
            annotation?.coordinate = map.userLocation.coordinate
            self.map.addAnnotation(annotation!)
            
        
        }else{
            let js = db![indexPath.row-1]
            if let corr = js.valueForKey("geometry")?.valueForKey("location"){
                if let lat = corr.valueForKey("lat") as? Double, let lng = corr.valueForKey("lng") as? Double {
                    self.map.removeAnnotations(self.map.annotations)
                    
                    if let bounds = js.valueForKey("geometry")?.valueForKey("bounds"){
                        if let northeast = bounds.valueForKey("northeast"){
                            let pointALocation = CLLocation(latitude: lat, longitude: lng)
                            let pointBLocation = CLLocation(latitude: (northeast.valueForKey("lat") as! Double), longitude: (northeast.valueForKey("lng") as! Double))
                            let d = pointALocation.distanceFromLocation(pointBLocation)
                            let r = MKCoordinateRegionMakeWithDistance(pointALocation.coordinate,
                                                                       d * 2, d * 2)
                            self.map.setRegion(r, animated: true)
                            
                        }
                    }else{
                        let r = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat , lng),
                                                                   500, 500)
                        self.map.setRegion(r, animated: true)
                    }
                    
                    annotation  = CustomAnnotation(coordinate: CLLocationCoordinate2DMake(lat , lng))
                    annotation?.coordinate = CLLocationCoordinate2DMake(lat , lng)
                    self.map.addAnnotation(annotation!)
                    
                    //annotation?.coordinate =
                }
            }
        }
        
    }

}
