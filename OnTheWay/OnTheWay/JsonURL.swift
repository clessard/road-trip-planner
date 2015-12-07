//
//  JsonURL.swift
//  OnTheWay
//
//  Created by Ellen Seidel on 10/31/15.
//  Copyright © 2015 Carli Lessard. All rights reserved.
//

import Foundation
import SwiftyJSON

public class JsonURL {
    
    private var url: NSString
    
    public init(url: NSString)
    {
        self.url = url
    }
    
    enum AwfulError: ErrorType {
        case Bad
        case Worse
        case Terrible
    }
    
    //returns an NSURL from url that can be used to get a JSON file
    private func getJSONURL() -> NSURL
    {
        let urlStr : NSString = self.url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        return searchURL
    }
    
    //returns the json file ready to be parsed
    private func getJsonFile() -> JSON
    {
        let jsonRequest: NSURL = getJSONURL()
        let jsonData = NSData(contentsOfURL: jsonRequest)
        let json = JSON(data: jsonData!)
        return json
    }
    
    //gets an encrypted polyline from a JSON file
    public func getEncryptedPolyline() -> JSON
    {
        let json = getJsonFile()
        let polyline = json["routes"][0]["overview_polyline"]["points"]
        return polyline
    }
    
    //sets the lat and lng values passed in based on the lat and lng value in the JSON file associated with url
    public func setLatandLng(inout lat: Double, inout lng: Double)
    {
        let json = getJsonFile()
        lat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
        lng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
    }
    
    //gets a list of possible addresses from a place/radarsearch url
    public func getPossibleAddresses(inout waypointOptions: NSMutableArray, inout waypointNameOptions: NSMutableArray)
    {
        let json = getJsonFile()
        let count = json["results"].count
        
        for var index = 0; index < count; ++index
        {
            let place_id = (json["results"][index]["place_id"]).stringValue
            let waypointInfo = JsonURL(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place_id + "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg")
            let address = waypointInfo.getAddress()
            let name = waypointInfo.getName()
            waypointOptions.addObject(address)
            waypointNameOptions.addObject(name)
        }
    }
    
    //gets the address from a place/details url
    private func getAddress() -> String
    {
        let json = getJsonFile()
        let address = (json["result"]["formatted_address"]).stringValue
        return address
    }
    
    //gets the name from a place/details url
    private func getName() -> String
    {
        let json = getJsonFile()
        let name = (json["result"]["name"]).stringValue
        return name
    }
    
    //gets the time a route will take
    public func getTime() -> Int
    {
        let json = getJsonFile()
        let count = (json["routes"][0]["legs"].count)
        var distance = 0
        
        for var i = 0; i < count; ++i
        {
            let legDist : Int = Int((json["routes"][0]["legs"][i]["duration"]["value"]).stringValue)!
            distance += legDist
        }
        return distance
    }
    
    //gets the time a route will take
    public func getDistance() -> Int
    {
        let json = getJsonFile()
        let count = (json["routes"][0]["legs"].count)
        var distance = 0
        
        for var i = 0; i < count; ++i
        {
            let legDist : Int = Int((json["routes"][0]["legs"][i]["distance"]["value"]).stringValue)!
            distance += legDist
        }
        return distance
    }
}
