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
import SwiftyJSON
import MapKit
import GoogleMaps


class appleMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var appleMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let polylineWidth : CGFloat = 5;
    
    let startIndex = 0
    let stopIndex = 1
    let wayPointIndex = 2
    
    var useCurrentLocation = false
    var waypointIsAddress = false
    
    var latArray = [0.0, 0.0, 0.0]
    var lngArray = [0.0, 0.0, 0.0]
    var addressArray = ["", "", ""]
    var pinNamesArray = ["start", "finish", "wayPoint"]
    
    var waypointAddressOptions : NSMutableArray = []
    var waypointNameOptions : NSMutableArray = []
    
    //button click that gets your directions from midPoint to the end of your route
    @IBAction func Navigate2(sender: AnyObject)
    {
        let endCoord = CLLocationCoordinate2D(latitude: latArray[stopIndex], longitude: lngArray[stopIndex])
        let midCoord = CLLocationCoordinate2D(latitude: latArray[wayPointIndex], longitude: lngArray[wayPointIndex])
        
        let stopMark = MKPlacemark(coordinate: endCoord, addressDictionary: nil)
        let midMark = MKPlacemark(coordinate: midCoord, addressDictionary: nil)
        
        let finish = MKMapItem(placemark: stopMark)
        let mid = MKMapItem(placemark: midMark)
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true]
        
        MKMapItem.openMapsWithItems([mid, finish], launchOptions: options as? [String : AnyObject])
    }
    
    //button click that gets you turn by turn directions from start to mid point
    @IBAction func Navigate(sender: AnyObject) {
        let startCoord = CLLocationCoordinate2D(latitude: latArray[startIndex], longitude: lngArray[startIndex])
        let midCoord = CLLocationCoordinate2D(latitude: latArray[wayPointIndex], longitude: lngArray[wayPointIndex])
        
        let startMark = MKPlacemark(coordinate: startCoord, addressDictionary: nil)
        let midMark = MKPlacemark(coordinate: midCoord, addressDictionary: nil)
        
        let start = MKMapItem(placemark: startMark)
        let mid = MKMapItem(placemark: midMark)
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true]
        
        MKMapItem.openMapsWithItems([start, mid], launchOptions: options as? [String : AnyObject])
        
    }
    
    //populates waypointOptions with the addresses on possible waypoints
    private func getPossibleWaypoints(start: String)
    {
        let location: String = addressArray[wayPointIndex] + "&location=" + start
        let possibleWaypoints = JsonURL(url: "https://maps.googleapis.com/maps/api/place/radarsearch/json?radius=50000&keyword=" + location + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg")
        possibleWaypoints.getPossibleAddresses(&waypointAddressOptions, waypointNameOptions: &waypointNameOptions)
    }
    
    //returns an NSString that is the correct url to use to request directions
    private func getDirectionsUrl() -> NSString
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
    
    //draws a marker on the map
    private func drawMarker(lat: Double, lng: Double, name: String)
    {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = MKPointAnnotation()
        marker.coordinate = location
        marker.title = name
        appleMapView.addAnnotation(marker)
    }
    
    //gets polyline info from Google Maps and puts it in a format MapKit can handle
    private func getPolyline() -> MKPolyline
    {
        let jsonDirURL = JsonURL(url: getDirectionsUrl())
        let encyptedPolyline = jsonDirURL.getEncryptedPolyline().string
        
        let directionsPath: GMSPath = GMSPath(fromEncodedPath: encyptedPolyline)
        let length = directionsPath.count()
        var pointsInLine: [CLLocationCoordinate2D] = []
        
        var i: UInt = 0
        for i = 0; i < length; ++i
        {
            pointsInLine.append(directionsPath.coordinateAtIndex(i))
        }
        let polyline = MKPolyline(coordinates: &pointsInLine, count: Int(length))
        return polyline
    }

    //creates a map with three points on it
    private func createMap()
    {
        // camera view is in the middle of the route
        let midx = (latArray[startIndex] + latArray[stopIndex])/2
        let midy = (lngArray[startIndex] + lngArray[stopIndex])/2
        
        let cameraPos = CLLocationCoordinate2D(latitude: midx, longitude: midy)
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegion(center: cameraPos, span: span)
        appleMapView.setRegion(region, animated: true)
        
        drawMarker(latArray[startIndex], lng: lngArray[startIndex], name: pinNamesArray[startIndex])
        drawMarker(latArray[stopIndex], lng: lngArray[stopIndex], name: pinNamesArray[stopIndex])
        drawMarker(latArray[wayPointIndex], lng: lngArray[wayPointIndex], name: pinNamesArray[wayPointIndex])
    }
    
    //sets the latitude and longitude values to the correct values based on the passed in addresses
    private func setLatandLng()
    {
        let length = addressArray.count
        for index in 0...length - 1
        {
            let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + addressArray[index])
            addressStr.setLatandLng(&latArray[index], lng: &lngArray[index])
        }
    }
    
    //sets the latitude and longitude values to the correct values based on the passed in addresses
    private func setMidLatandLng()
    {
        print("setting mid lat and lng")
        let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + addressArray[wayPointIndex])
        addressStr.setLatandLng(&latArray[wayPointIndex], lng: &lngArray[wayPointIndex])
    }
    
    //gets the shortest route of all the waypoint options
    private func findShortestRoute()
    {
        let start : String = "\(latArray[startIndex])" + "," + "\(lngArray[startIndex])"
        let stop : String = "\(latArray[stopIndex])" + "," + "\(lngArray[stopIndex])"
        let count = waypointNameOptions.count
        
        var minTime = 31540000      //initially set to the number of seconds in a year
        var tempAddress = ""
        var tempName = ""
        var dirUrl = NSString()
        
        for var i = 0; i < count; ++i
        {
            let midPoint : String = waypointAddressOptions[i] as! String
            dirUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&waypoints=" + midPoint + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
            let directionsURL = JsonURL(url: dirUrl)
            let time = directionsURL.getTime()
            
            if(time < minTime)
            {
                minTime = time
                tempAddress = waypointAddressOptions[i] as! String
                tempName = waypointNameOptions[i] as! String
            }
        }
        pinNamesArray[wayPointIndex] = tempName
        addressArray[wayPointIndex] = tempAddress
    }
    
    //renders the map on the screen based on user input
    override func viewDidLoad()
    {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        var start: String = ""
        
        super.viewDidLoad()
        self.appleMapView.delegate = self
        
        // Used to get the current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        //set the coordinates
        setLatandLng()
        if(useCurrentLocation)
        {
            latArray[startIndex] = locValue.latitude
            lngArray[startIndex] = locValue.longitude
        }
        start = "\(latArray[startIndex])" + "," + "\(lngArray[startIndex])"
        
        //check to see if we are searching for a generic waypoint
        if(waypointIsAddress == false)
        {
            print("checking for generic waypoint")
            getPossibleWaypoints(start)
            findShortestRoute()
            setMidLatandLng()
        }

        createMap()
        let polyline = getPolyline()
        appleMapView.addOverlay(polyline)
    }
    
    //function that renders the polyline on the screen. Not entirely sure how this works.
    //It is never call. Code modified slightly from
    //http://rshankar.com/how-to-add-mapview-annotation-and-draw-polyline-in-swift/
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = polylineWidth
            return polylineRenderer
        }
        return nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}