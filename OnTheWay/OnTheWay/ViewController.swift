//
//  MapViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

//Notes on Ellen's Code: You can now have a user input an address for start, stop, and midpoint and
//                       the code will render these 3 point on a screen. Although the user input is 
//                       woorking, there are other cases of hard cpding going on. Moving forward we
//                       probably want to change this. Some instance of hard coding: zoom level, the
//                       if cases in setLatandLong(). Additionally, the code is repetative and could
//                       probably use more helper functions to make things cleaner. Also, the variable
//                       naming for the end destination and the waypoint is inconsistent. We whould use
//                       a common convention for variable (i think?)
//Part of code from: http://stackoverflow.com/questions/28514622/convert-string-to-nsurl-is-return-nil-in-swift

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
    
    //helper function for viewDidLoad()
    //takes in an address in string form and returns an NSURL that can be used to get a JSON file
    func getJSONURL(address: String) -> NSURL {
        var url : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)"
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var searchURL : NSURL = NSURL(string: urlStr as String)!
        println(searchURL)
        return searchURL
    }
    
    //helper function for viewDidLoad
    //sets the latitude and longitude values for a certain destination
    //takes in a NSURL and a string telling you what lat and long values to set
    //gets and parses the correct JSON file
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
        if(typeOfAddress == "wayPoint"){
            self.wayPointLat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
            self.wayPointLng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        }
    }

    //helper function for viewDidLoad()
    //creates a map with three points on it
    func createMap() {
        var camera = GMSCameraPosition.cameraWithLatitude(self.startLat,
            longitude: self.startLng, zoom: 13)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2DMake(self.startLat, self.startLng)
        startMarker.title = "Start"
        startMarker.map = mapView
        
        
        var stopMarker = GMSMarker()
        stopMarker.position = CLLocationCoordinate2DMake(self.stopLat, self.stopLng)
        stopMarker.title = "End"
        stopMarker.map = mapView
        
        var midMarker = GMSMarker()
        midMarker.position = CLLocationCoordinate2DMake(self.wayPointLat, self.wayPointLng)
        midMarker.title = "Middle Destination"
        midMarker.map = mapView
        
    }
    
    
    
    
    
    //renders the mpa on the screen based on user input
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var startAddress = getJSONURL(self.startAddress)
        var stopAddress = getJSONURL(self.stopAddress)
        var midPointAddress = getJSONURL(wayPointAddress)
        
        setLatandLong(startAddress, typeOfAddress: "start")
        setLatandLong(stopAddress, typeOfAddress: "stop")
        setLatandLong(midPointAddress, typeOfAddress: "wayPoint")

        createMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

