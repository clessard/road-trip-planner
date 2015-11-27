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