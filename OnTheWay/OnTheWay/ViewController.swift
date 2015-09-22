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
    
    var startLat = 0.0
    var startLng = 0.0
    
    var stopLat = 0.0
    var stopLng = 0.0
    
    var wayPointLat = 0.0
    var wayPointLng = 0.0
    
    
    var startAddress = ""
    var stopAddress = ""
    var wayPointAddress = ""
    
    
    
    func getJSONURL(address: String) -> NSURL {
        
        let modifiedAddress = String(map(address.generate()) {
            $0 == " " ? "%" : $0
            })
        
        let jsonString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + modifiedAddress
        println(jsonString)
        
        var jsonRequest = NSURL(string: jsonString)
        println(jsonRequest)
        return jsonRequest
    }
    
    func setLatandLong(jsonRequest: NSURL, typeOfAddress: String) {
        var jsonData = NSData(contentsOfURL: jsonRequest)
        let json = JSON(data: jsonData!)
        if(typeOfAddress == "start") {
            self.startLat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
            self.startLng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        }
        if(typeOfAddress == "stop") {
            self.stopLat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
            self.stopLng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        }
        else{
            self.wayPointLat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
            self.wayPointLng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        }
    }

    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let modifiedStart = String(map(self.startAddress.generate()) {
            $0 == " " ? "%" : $0
            })
        let modifiedStop = String(map(self.stopAddress.generate()) {
            $0 == " " ? "%" : $0
            })
        let modifiedWayPoint = String(map(self.wayPointAddress.generate()) {
            $0 == " " ? "%" : $0
            })
        
        var jsonString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + fixedAddress
        
        println(jsonString)

        
        var jsonRequest = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=" + fixedAddress)
        
        println(jsonRequest)

*/
        
        //var jsonData = NSData(contentsOfURL: jsonRequest!)
        
        //let json = JSON(data: jsonData!)
        
        
        
        
        
        var address = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=225%20Joe%20English%20Rd%20New%20Boston%20NH")
        
        var jsonData = NSData(contentsOfURL: address!)
        
        let json = JSON(data: jsonData!)
        
        
        
        
        //println(json)
        
        println(json["results"][0]["geometry"]["location"]["lat"])
        println(json["results"][0]["geometry"]["location"]["lng"])
        
        self.startLat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
        self.startLng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        
        //println(latitudePassed)
        var camera = GMSCameraPosition.cameraWithLatitude(self.startLat,
            longitude: self.startLng, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.startLat, self.startLng)
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

