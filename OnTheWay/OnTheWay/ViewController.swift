//
//  MapViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class ViewController: UIViewController {
    
    var latitude = 0.0
    var longitude = 0.0
    var address = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixedAddress = String(map(self.address.generate()) {
            $0 == " " ? "%" : $0
            })
        
        var jsonString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + fixedAddress
        
        println(jsonString)
        
        var jsonRequest = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=" + fixedAddress)
        
        println(jsonRequest)
        
        //var jsonData = NSData(contentsOfURL: jsonRequest!)
        
        //let json = JSON(data: jsonData!)
        
        
        
        
        
        var address = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=225%20Joe%20English%20Rd%20New%20Boston%20NH")
        
        var jsonData = NSData(contentsOfURL: address!)
        
        let json = JSON(data: jsonData!)
        
        
        
        
        //println(json)
        
        println(json["results"][0]["geometry"]["location"]["lat"])
        println(json["results"][0]["geometry"]["location"]["lng"])
        
        self.latitude = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
        self.longitude = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        
        //println(latitudePassed)
        var camera = GMSCameraPosition.cameraWithLatitude(self.latitude,
            longitude: self.longitude, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    
    
    //var latitudePassed = 0.0
    //var longitude = 0.0
    
    
    /*
    
    override func viewDidLoad() {
    println("entered map")
    super.viewDidLoad()
    
    /*
    var address = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=225%20Joe%20English%20Rd%20New%20Boston%20NH")
    
    var jsonData = NSData(contentsOfURL: address!)
    
    let json = JSON(data: jsonData!)
    
    //println(json)
    
    println(json["results"][0]["geometry"]["location"]["lat"])
    println(json["results"][0]["geometry"]["location"]["lng"])
    
    self.latitudePassed = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
    self.longitude = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
    
    
    
    var camera = GMSCameraPosition.cameraWithLatitude(self.latitudePassed, longitude: self.longitude, zoom: 12)
    var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
    self.view = mapView
    
    */
    
    println("get camera")
    var camera = GMSCameraPosition.cameraWithLatitude(151,
    longitude: -31, zoom: 6)
    
    println("get map")
    var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
    
    
    mapView.myLocationEnabled = true
    self.view = mapView
    
    var marker = GMSMarker()
    marker.position = CLLocationCoordinate2DMake(self.latitudePassed, self.longitude)
    marker.title = "Sydney"
    marker.snippet = "Australia"
    marker.map = mapView
    // Do any additional setup after loading the view, typically from a nib.
    
    
    }
    */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

