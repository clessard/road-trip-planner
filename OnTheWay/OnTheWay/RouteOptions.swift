//
//  RouteOptions.swift
//  OnTheWay
//
//  Created by Ellen Seidel on 11/26/15.
//  Copyright © 2015 Carli Lessard. All rights reserved.
//


//waypointOptions is empty if an addres was passed into the waypoint field by the user!!

import Foundation

public class RouteOptions{
    
    //public data members
    public var waypointOptions: [WaypointOption] = []
    public var latArray = [0.0, 0.0, 0.0]
    public var lngArray = [0.0, 0.0, 0.0]
    public var pinNamesArray = ["start", "finish", "wayPoint"]
    
    //private data members
    private let locationManager = CLLocationManager()
    private var waypointAddressOptions : NSMutableArray = []
    private var waypointNameOptions : NSMutableArray = []
    
    //these get passed in based on what the user enters
    private var addressArray = ["", "", ""]
    private var useCurrentLocation = false
    private var waypointIsAddress = false
    
    public init(addressArray: [String], useCurrentLocation: Bool, waypointIsAddress: Bool)
    {
        self.addressArray = addressArray
        self.useCurrentLocation = useCurrentLocation
        self.waypointIsAddress = waypointIsAddress
        getArray()
    }
    
    private func getArray()
    {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        var start: String = ""

        setAllLatLng()
        if(useCurrentLocation)
        {
            latArray[startIndex] = locValue.latitude
            lngArray[startIndex] = locValue.longitude
        }
        
        start = "\(latArray[startIndex])" + "," + "\(lngArray[startIndex])"
        
        if(waypointIsAddress == false)
        {
            getPossibleWaypoints(start)
            addWaypoints()
        }
    }
    
    //populates waypointAddressOptions and waypointNameOptions with the addresses on possible waypoints
    private func getPossibleWaypoints(start: String)
    {
        let location: String = addressArray[wayPointIndex] + "&location=" + start
        let possibleWaypoints = JsonURL(url: "https://maps.googleapis.com/maps/api/place/radarsearch/json?radius=50000&keyword=" + location + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg")
        possibleWaypoints.getPossibleAddresses(&waypointAddressOptions, waypointNameOptions: &waypointNameOptions)
    }
    
    //sets the latitude and longitude values based on the address array
    private func setAllLatLng()
    {
        let length = addressArray.count
        for index in 0...length - 1
        {
            let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + addressArray[index])
            addressStr.setLatandLng(&latArray[index], lng: &lngArray[index])
        }
    }
    
    //sets the latitude and longitude values to the correct values based on the passed in addresses
    private func setOneLatLng(inout lat: Double, inout lng:Double, address: String)
    {
        print("setting mid lat and lng")
        let addressStr = JsonURL(url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + address)
        addressStr.setLatandLng(&lat, lng: &lng)
    }
    
    //adds all the waypoints to waypointOptions
    private func addWaypoints()
    {
        let start : String = "\(latArray[startIndex])" + "," + "\(lngArray[startIndex])"
        let stop : String = "\(latArray[stopIndex])" + "," + "\(lngArray[stopIndex])"
        let count = waypointAddressOptions.count
        var dirUrl = NSString()
        var lat = 0.0
        var lng = 0.0
        
        //loops through waypointAddressOptions to check each waypoint
        for var i = 0; i < count; ++i
        {
            let waypointAdd : String = waypointAddressOptions[i] as! String
            let waypointName : String = waypointNameOptions[i] as! String
            
            dirUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=" + start + "&destination=" + stop + "&waypoints=" + waypointAdd + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
            let directionsURL = JsonURL(url: dirUrl)
            
            let time = directionsURL.getTime()
            let dist = directionsURL.getDistance()
            setOneLatLng(&lat, lng: &lng, address: waypointAdd)
            let waypoint = WaypointOption(routeTime: time, routeDistance: dist, name: waypointName,
                                          lat: lat, lng: lng, address: waypointAdd)
            
            waypointOptions.append(waypoint)
        }
        sort()
    }
    
    //sorts the waypoint array from shortest to longest time. Uses Selection sort. Need to change this!!
    private func sort()
    {
        let count = waypointOptions.count
        
        for var i = 0; i < count; ++i
        {
            let unsortedMin = waypointOptions[i]
            var min = waypointOptions[i]
            var minIndex = i
            
            for var j = i; j < count; ++j
            {
                let currentPoint = waypointOptions[j]
                if(currentPoint.isLessThan(min))
                {
                    min = currentPoint
                    minIndex = j
                }
            }
            waypointOptions[i] = min
            waypointOptions[minIndex] = unsortedMin
        }
    }


}