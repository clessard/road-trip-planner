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
    let polylineWidth : CGFloat = 5;
    let startIndex = 0
    let stopIndex = 1
    let wayPointIndex = 2
    
    var useCurrentLocation = false
    
    var latArray = [0.0, 0.0, 0.0]
    var lngArray = [0.0, 0.0, 0.0]
    var addressArray = ["", "", ""]

    
    //gets the correct url to use to request directions
    func getDirectionsUrl() -> NSString
    {
        let start : String = "\(latArray[startIndex])" + "," + "\(lngArray[startIndex])"
        let stop : String = "\(latArray[stopIndex])" + "," + "\(lngArray[stopIndex])"
        let midPoint : String = "\(latArray[wayPointIndex])" + "," + "\(lngArray[wayPointIndex])"
        var url  = NSString()
        
        if(addressArray[wayPointIndex] == "")
        {
            url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
        }
        else
        {
            url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&waypoints=" + midPoint + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
        }
        return url
    }

    
    /**
    * Function used to get the current location of the phone
    */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        // Shows the current location on the map if the app is authorized to do so
        if status == .AuthorizedWhenInUse
        {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    //draws a marker on the map
    func drawMarker(lat: Double, lng: Double, address: String)
    {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        marker.title = address
        marker.map = mapView
    }

    //creates a map with three points on it and a polyline of the route
    func createMap()
    {
        //getting polyline info
        let jsonDirURL = JsonURL(url: getDirectionsUrl())
        let encyptedPolyline = jsonDirURL.getEncryptedPolyline().string
        let directionsPath: GMSPath = GMSPath(fromEncodedPath: encyptedPolyline)
        let routePolyline = GMSPolyline(path: directionsPath)
        
        // adapting zoom given start to finish distance
        let x = latArray[startIndex] - latArray[stopIndex]
        let y = lngArray[startIndex] - lngArray[stopIndex]
        let routeDist = sqrt(pow(x,2) + pow(y,2))
        
        // camera view is in the middle of the route
        let midx = (latArray[startIndex] + latArray[stopIndex])/2
        let midy = (lngArray[startIndex] + lngArray[stopIndex])/2
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(midx, longitude: midy, zoom: 4)
        //self.wayPointLat,longitude: self.wayPointLng, zoom: Float(Int((1/routeDist) * 7)))
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.settings.compassButton = true
        let mapInsets = UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
        mapView.padding = mapInsets
        mapView.myLocationEnabled = true
        self.view = mapView
        
        //draw start, stop, and wayPoint on the map
        drawMarker(latArray[startIndex], lng: lngArray[startIndex], address: addressArray[startIndex])
        drawMarker(latArray[stopIndex], lng: lngArray[stopIndex], address: addressArray[stopIndex])
        drawMarker(latArray[wayPointIndex], lng: lngArray[wayPointIndex], address: addressArray[wayPointIndex])
        
        routePolyline.strokeWidth = polylineWidth
        routePolyline.map = mapView
        
        //mapView.mapType = kGMSTypeSatellite
        //let minimumPath = GMSPolyline(path: minPaths[0])
        //minimumPath.map = mapView
        
    }
    
    //sets the latitude and longitude values to the correct values based on the passed in addresses
    func setLatandLng(addresses: [String], inout lats: [Double], inout lngs: [Double])
    {
        let length = addresses.count
        for index in 0...length - 1
        {
            let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + addresses[index])
            addressStr.setLatandLng(&lats[index], lng: &lngs[index])
        }
    }
    
    //renders the map on the screen based on user input
    override func viewDidLoad()
    {
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        super.viewDidLoad()
        
        // Used to get the current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        setLatandLng(addressArray, lats: &latArray, lngs: &lngArray)
        
        // Sets the start location to the current location if necessary
        if(useCurrentLocation)
        {
            latArray[startIndex] = locValue.latitude
            lngArray[startIndex] = locValue.longitude
        }

        createMap()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

