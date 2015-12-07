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


//global constants
let startIndex = 0
let stopIndex = 1
let wayPointIndex = 2

class appleMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var appleMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let polylineWidth : CGFloat = 5;
    
    //to tell if the user pickedan option from the route options table
    var fromRouteOptionsTable = false;
    
    //to be passed to RouteOptions object
    var useCurrentLocation = false
    var waypointIsAddress = false
    var addressArray = ["", "", ""]
    
    //stuff to get from RouteOptions
    var latArray = [0.0, 0.0, 0.0]
    var lngArray = [0.0, 0.0, 0.0]
    var pinNamesArray = ["start", "finish", "wayPoint"]
    
    // Route options set by the table, index of which option chosen
    var routeOptions = RouteOptions()
    var routeOptionsEllen = RouteOptions()
    var index = 0
    
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
    
    private func setLatandLng()
    {
        let length = addressArray.count
        for index in 0...length - 1
        {
            let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + addressArray[index])
            addressStr.setLatandLng(&latArray[index], lng: &lngArray[index])
        }
    }
    
    //renders the map on the screen based on user input
    override func viewDidLoad()
    {
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
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            latArray[startIndex] = locValue.latitude
            lngArray[startIndex] = locValue.longitude
        }
        
        let routeOptionsEllen = RouteOptions(addressArray: addressArray, useCurrentLocation: useCurrentLocation,
            waypointIsAddress:waypointIsAddress)

        //handles the case where the waypoint is generic and the user did not pick from the route options table
        if(routeOptionsEllen.waypointOptions.count != 0 && !fromRouteOptionsTable)
        {
            latArray = routeOptionsEllen.latArray
            lngArray = routeOptionsEllen.lngArray
            
            let waypointOption = routeOptionsEllen.waypointOptions[0]
            let lat = waypointOption.getLat()
            let lng = waypointOption.getLng()
            let address = waypointOption.getAddress()
            let name = waypointOption.getName()
            
            
            //set all the values in the arrays correctly
            latArray[wayPointIndex] = lat
            lngArray[wayPointIndex] = lng
            addressArray[wayPointIndex] = address
            pinNamesArray[wayPointIndex] = name
            
        }
        else if (fromRouteOptionsTable)
        {
            latArray = routeOptions.latArray
            lngArray = routeOptions.lngArray
            let waypointOption = routeOptions.waypointOptions[index]
            latArray[wayPointIndex] = waypointOption.getLat()
            lngArray[wayPointIndex] = waypointOption.getLng()
            addressArray[wayPointIndex] = waypointOption.getAddress()
            pinNamesArray[wayPointIndex] = waypointOption.getName()
        }
        //if they did not gick a generic waypoint
        else
        {
            
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