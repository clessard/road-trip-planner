//
//  MapViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

// Notes on Ellen's Code: You can now have a user input an address for start, stop, and midpoint and
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


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // The view that is the Google map
    @IBOutlet var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    var useCurrentLocation = false
    
    var startLat = 0.0
    var startLng = 0.0
    
    var stopLat = 0.0
    var stopLng = 0.0
    
    var wayPointLat = -424242.0
    var wayPointLng = -424242.0
    
    
    var startAddress = ""
    var stopAddress = ""
    var wayPointAddress = ""
    
    //helper function for viewDidLoad()
    //takes in an address in string form and returns an NSURL that can be used to get a JSON file
    func getJSONURL(address: String) -> NSURL {
        let url : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)"
        let urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        //print(searchURL, terminator: "")
        return searchURL
    }
    
    //gets the JSON url necesary to get directions
    func getDirectionsURl() -> NSURL
    {
        let start : String = "\(startLat)" + "," + "\(startLng)"
        let stop : String = "\(stopLat)" + "," + "\(stopLng)"
        let midPoint : String = "\(wayPointLat)" + "," + "\(wayPointLng)"
        var url = NSString()
        
        print(midPoint)
        print("waypoint address is")
        print(wayPointAddress)
        print(wayPointAddress == "")
        if(wayPointAddress == "")
        {
            print("hit option 1")
            url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
        }
        if(wayPointAddress != "")
        {
            print("hit option 2")
            url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&waypoints=" + midPoint + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
        }
        let urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        print(searchURL)
        return searchURL
    }
    
    func getEncryptedPolyline(jsonRequest: NSURL) -> JSON
    {
        let jsonData = NSData(contentsOfURL: jsonRequest)
        let json = JSON(data: jsonData!)
        let polyline = json["routes"][0]["overview_polyline"]["points"]
        //print(json)
        //print(json["routes"])
        //print(json["routes"][0]["overview_polyline"])
        //print(polyline)
        return polyline
    }
    
    //helper function for viewDidLoad
    //sets the latitude and longitude values for a certain destination
    //takes in a NSURL and a string telling you what lat and long values to set
    //gets and parses the correct JSON file
    func setLatandLong(jsonRequest: NSURL, typeOfAddress: String) {
        let jsonData = NSData(contentsOfURL: jsonRequest)
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
    
    /**
    * Function used to get the current location of the phone
    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        // Shows the current location on the map if the app is authorized to do so
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    

    //helper function for viewDidLoad()
    //creates a map with three points on it
    func createMap() {
        
        
        print("creating map")
        
        let jsonRequest = getDirectionsURl()
        let encyptedPolyline = getEncryptedPolyline(jsonRequest).string
        
        //var polyline = googlemaps.geometry.encoding.decodePath(encyptedPolyline)
        
        let path6: GMSPath = GMSPath(fromEncodedPath: encyptedPolyline)
        let routePolyline = GMSPolyline(path: path6)
        //routePolyline.map = mapView
        
        print("printed polyline")
        
        // adapting zoom given start to finish distance
        let x = self.startLat - self.stopLat
        let y = self.startLng - self.stopLng
        let routeDist = sqrt(pow(x,2) + pow(y,2))
        
        // camera view is in the middle of the route
        let midx = (self.startLat + self.stopLat)/2
        let midy = (self.startLng + self.stopLng)/2
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(midx, longitude: midy, zoom: 4)
            //self.wayPointLat,longitude: self.wayPointLng, zoom: Float(Int((1/routeDist) * 7)))
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.settings.compassButton = true
        let mapInsets = UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
        mapView.padding = mapInsets
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2DMake(self.startLat, self.startLng)
        startMarker.title = "Start"
        startMarker.map = mapView
        
        let stopMarker = GMSMarker()
        stopMarker.position = CLLocationCoordinate2DMake(self.stopLat, self.stopLng)
        stopMarker.title = "End"
        stopMarker.map = mapView
        
        let midMarker = GMSMarker()
        midMarker.position = CLLocationCoordinate2DMake(self.wayPointLat, self.wayPointLng)
        midMarker.title = "Middle Destination"
        midMarker.map = mapView
        
        routePolyline.strokeWidth = 5
        routePolyline.map = mapView
        
        // change map view type
        
        //mapView.mapType = kGMSTypeSatellite
        
        
        //let minimumPath = GMSPolyline(path: minPaths[0])
        //minimumPath.map = mapView
        
    }
    
    
    //renders the map on the screen based on user input
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Used to get the current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        let startAddress = getJSONURL(self.startAddress)
        let stopAddress = getJSONURL(self.stopAddress)
        let midPointAddress = getJSONURL(wayPointAddress)
        
        setLatandLong(startAddress, typeOfAddress: "start")
        setLatandLong(stopAddress, typeOfAddress: "stop")
        setLatandLong(midPointAddress, typeOfAddress: "wayPoint")
        
        // Sets the start location to the current location if necessary
        if(useCurrentLocation) {
            self.startLat = locValue.latitude
            self.startLng = locValue.longitude
        }

        createMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

