//
//  WaypointOption.swift
//  OnTheWay
//
//  Created by Ellen Seidel on 11/25/15.
//  Copyright © 2015 Carli Lessard. All rights reserved.
//

import Foundation

public class WaypointOption {
    
    public var routeTime: Int
    public var routeDistance: Int
    public var name: String
    
    public init(routeTime: Int, routeDistance: Int, name: String)
    {
        self.routeTime = routeTime
        self.routeDistance = routeDistance
        self.name = name
    }
}

func < (LHS: WaypointOption, RHS: WaypointOption) -> Bool
{
    if(LHS.routeTime < RHS.routeTime)
    {
        return true
    }
    else
    {
        return false
    }
}