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
    
    //returns an NSURL from url that can be used to get a JSON file
    private func getJSONURL() -> NSURL
    {
        let urlStr : NSString = self.url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        return searchURL
    }
    
    //gets an encrypted polyline from a JSON file
    public func getEncryptedPolyline() -> JSON
    {
        let jsonRequest: NSURL = getJSONURL()
        let jsonData = NSData(contentsOfURL: jsonRequest)
        let json = JSON(data: jsonData!)
        let polyline = json["routes"][0]["overview_polyline"]["points"]
        return polyline
    }
    
    //sets the lat and lng values passed in based on the lat and lng value in the JSON file associated with url
    public func setLatandLng(inout lat: Double, inout lng: Double) {
        print("latBefore")
        print(lat)
        let jsonRequest: NSURL = getJSONURL()
        let jsonData = NSData(contentsOfURL: jsonRequest)
        let json = JSON(data: jsonData!)
        lat = (json["results"][0]["geometry"]["location"]["lat"]).doubleValue
        lng = (json["results"][0]["geometry"]["location"]["lng"]).doubleValue
        print("latAfter")
        print(lat)
    }
}
