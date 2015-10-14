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
    
    var wayPointLat = 0.0
    var wayPointLng = 0.0
    
    
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
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
        
        // adapting zoom given start to finish distance
        let x = self.startLat - self.stopLat
        let y = self.startLng - self.stopLng
        var routeDist = sqrt(pow(x,2) + pow(y,2))
        
        let camera = GMSCameraPosition.cameraWithLatitude(self.startLat, longitude: self.startLng, zoom: 13)
            //self.wayPointLat,longitude: self.wayPointLng, zoom: Float(Int((1/routeDist) * 7)))
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.settings.compassButton = true
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
        
        
        
        // change map view type
        
        //mapView.mapType = kGMSTypeSatellite
        
        
        
        //        var mapInsets = UIEdgeInsetsMake(100.0, 100.0, 100.0, 300.0)
        //
        //        mapView.padding = mapInsets
        mapView.myLocationEnabled = true
        self.view = mapView
        
        
        var start = GMSMarker()
        //        start.position = CLLocationCoordinate2DMake(34.1100, -117.7197)
        //
        //        start.title = "Claremont"
        //
        //        start.snippet = "California"
        //
        //        start.map = mapView
        start = startMarker
        
        
        var end = GMSMarker()
        //        end.position = CLLocationCoordinate2DMake(34.0219, -118.4814)
        //
        //        end.title = "Santa Monica"
        //
        //        end.snippet = "California"
        //
        //        end.map = mapView
        end = stopMarker
        
        
        // calculate start stop distance
        let xDist = start.position.latitude - end.position.latitude
        let yDist = start.position.longitude - end.position.longitude
        var STARTtoSTOP = sqrt(pow(xDist,2) + pow(yDist,2))
        
        // calculate most north, east, west, and south points on route
        var North = max(start.position.latitude,end.position.latitude) + 0.15 * STARTtoSTOP
        var South = min(start.position.latitude,end.position.latitude) - 0.15 * STARTtoSTOP
        var East = max(start.position.longitude,end.position.longitude) + 0.15 * STARTtoSTOP
        var West = min(start.position.longitude,end.position.longitude) - 0.15 * STARTtoSTOP
        
        // draw search region box
        var path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2DMake(North, West))
        path.addCoordinate(CLLocationCoordinate2DMake(North, East))
        path.addCoordinate(CLLocationCoordinate2DMake(South, East))
        path.addCoordinate(CLLocationCoordinate2DMake(South, West))
        path.addCoordinate(CLLocationCoordinate2DMake(North, West))
        var rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
        
        
        
        var stop1 = GMSMarker()
        //        stop1.position = CLLocationCoordinate2DMake(34.4238, -118.5971)
        //
        //        stop1.title = "Six FLags"
        //
        //        stop1.snippet = "California"
        stop1.map = mapView
        
        
        
        var stop2 = GMSMarker()
        //        stop2.position = CLLocationCoordinate2DMake(34.1561, -118.1319)
        //
        //        stop2.title = "Pasadena"
        //
        //        stop2.snippet = "California"
        //
        //        stop2.map = mapView
        stop2 = midMarker
        
        
        
        var stop3 = GMSMarker()
        //        stop3.position = CLLocationCoordinate2DMake(33.8003, -117.8828)
        //
        //        stop3.title = "Angels Stadium"
        //
        //        stop3.snippet = "California"
        stop3.map = mapView
        
        
        var path1 = GMSMutablePath()
        path1.addCoordinate(start.position)
        path1.addCoordinate(stop1.position)
        path1.addCoordinate(end.position)
        var startStop1 = start.position
        
        var path2 = GMSMutablePath()
        path2.addCoordinate(start.position)
        path2.addCoordinate(stop2.position)
        path2.addCoordinate(end.position)
        
        var path3 = GMSMutablePath()
        path3.addCoordinate(start.position)
        path3.addCoordinate(stop3.position)
        path3.addCoordinate(end.position)
        
        var stops = [stop1,stop2,stop3]
        var paths = [path1,path2,path3]
        
        
        
        /*
        
        Calculates min path and returns lists that will be used for user selection page
        
        */
        
        func GetMinPath(inout paths: [GMSMutablePath],inout stops: [GMSMarker],start: GMSMarker,end: GMSMarker) -> ([GMSMutablePath],[Double],[Double],[Double],Double){
            
            var minPath = GMSMutablePath()
            
            // gets min path from list of paths
            func MINPATH(paths: [GMSMutablePath],stops: [GMSMarker]) -> (Double , GMSMutablePath){
                var minDist = 1000000000.0
                var minPath = GMSMutablePath()
                for var index = 0; index < paths.count; ++index {
                    let xDist1 = start.position.latitude - stops[index].position.latitude
                    let yDist1 = start.position.longitude - stops[index].position.longitude
                    let xDist2 = end.position.latitude - stops[index].position.latitude
                    let yDist2 = end.position.longitude - stops[index].position.longitude
                    let totalDistance = sqrt(pow(xDist1,2) + pow(yDist1,2)) + sqrt(pow(xDist2,2) + pow(yDist2,2))
                    if minDist > totalDistance{
                        minDist = totalDistance
                        minPath = paths[index]
                    }
                }
                return (minDist,minPath)
            }
            var minPaths = [GMSMutablePath]()
            var minDists = [Double]()
            var minDist = 0.0
            
            // ordering paths by distance
            while(paths.count != 0){
                (minDist,minPath) = MINPATH(paths, stops: stops)
                minPaths.append(minPath)
                minDists.append(minDist)
                var tempPaths = [GMSMutablePath] ()
                var tempStops = [GMSMarker] ()
                for var i = 0; i < paths.count; ++i {
                    if (paths[i] != minPath){
                        tempPaths.append(paths[i])
                        tempStops.append(stops[i])
                    }
                }
                paths = tempPaths
                stops = tempStops
            }
            
            
            // calculating things needed for Routes View Controller
            minPath = minPaths[0]
            let xDist = start.position.latitude - end.position.latitude
            let yDist = start.position.longitude - end.position.longitude
            var totalTime = [Double] ()
            var timeAdded = [Double] ()
            let STARTtoSTOP = sqrt(pow(xDist,2) + pow(yDist,2))
            for var i = 0; i < minPaths.count; ++i {
                totalTime.append(minDists[i])
                timeAdded.append(minDists[i] - STARTtoSTOP)
            }
            return (minPaths,minDists,totalTime,timeAdded,STARTtoSTOP)
        }
        
        var minPaths = [GMSMutablePath]()
        var minDists = [Double]()
        var totalTime = [Double]()
        var timeAdded = [Double]()
        (minPaths,minDists,totalTime,timeAdded,STARTtoSTOP) = GetMinPath(&paths,stops: &stops,start: start,end: end)
        
        func ListPaths(totalTime: [Double], timeAdded: [Double], minDists: [Double], StartToFinish: Double) -> (Path: [String], Added: [String]){
            var Path = [String]()
            var Added = [String]()
            for var i = 0; i < totalTime.count; ++i {
                Path.append("Total distance of route: " + String(stringInterpolationSegment: totalTime[i]))
                Added.append("Distance added to original: " + String(stringInterpolationSegment: timeAdded[i]))
            }
            print(Path, terminator: "")
            return (Path,Added)
        }
        
        let minimumPath = GMSPolyline(path: minPaths[0])
        minimumPath.map = mapView
        
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

