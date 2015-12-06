//
//  WaypointOption.swift
//  OnTheWay
//
//  Created by Ellen Seidel on 11/25/15.
//  Copyright © 2015 Carli Lessard. All rights reserved.
//

import Foundation

public class WaypointOption {
    
    private var routeTime: Int
    private var routeDistance: Int
    
    private var name: String
    private var lat: Double
    private var lng: Double
    private var address: String
    
    public init()
    {
        self.routeTime = 0
        self.routeDistance = 0
        self.name = ""
        self.lat = 0.0
        self.lng = 0.0
        self.address = ""
    }
    
    public init(routeTime: Int, routeDistance: Int, name: String,
                lat: Double, lng: Double, address: String)
    {
        self.routeTime = routeTime
        self.routeDistance = routeDistance
        self.name = name
        self.lat = lat
        self.lng = lng
        self.address = address
    }
    
    //compares the times of 2 WaypointOption objects
    public func isLessThan(other: WaypointOption) -> Bool
    {
        let otherTime = other.getTime()
        
        if(routeTime < otherTime)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //functions to access data members (read only)
    public func getTime() -> Int
    {
        return routeTime
    }
    public func getAdjustedTime() -> String
    {
        let minutes : Int = routeTime/60
        let hours : Int = minutes/60
        let remainder : Int = minutes % 60
        if remainder < 10 {
            return "\(hours):0\(remainder)"
        }
        return "\(hours):\(remainder)"
    }
    public func getDist() -> Int
    {
        return routeDistance
    }
    public func getName() -> String
    {
        return name
    }
    public func getAddress() -> String
    {
        return address
    }
    public func getLat() -> Double
    {
        return lat
    }
    public func getLng() -> Double
    {
        return lng
    }
}