//
//  RoutesViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var startAddress = ""
    var stopAddress = ""
    var wayPointAddress = ""
    var useCurrentLoc = Bool()
    var waypointIsAddr = Bool()
    var fromMap: Bool = false
    
    // Used to hold the strings in the table
    var routes = [String]()
    
    let startIndex = 0;
    let stopIndex = 1;
    let wayPointIndex = 2;
    var addressArray = ["", "", ""]
    
    // Used to hold the actual waypoint information to generate routes
    var routeOptions = RouteOptions()
    var index = 0
    
    @IBOutlet weak var routesTableView: UITableView!    
    
    // Defines the number of sections in the table. Currently only uses one
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Defines how many rows there are in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableSize = 10
        if(routeOptions.waypointOptions.count < 11){
            tableSize = routeOptions.waypointOptions.count
        }
        return tableSize
    }
    
    // Fills the table with the information from routes array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel!.text = routeOptions.waypointOptions[row].getName()
        cell.detailTextLabel!.text = "Time: \(routeOptions.waypointOptions[row].getAdjustedTime())"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
    }
    
    // Loads the display
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routesTableView.delegate = self
        routesTableView.dataSource = self

        // Calculate the waypoint options
        if(!fromMap) {
            routeOptions = RouteOptions(addressArray: addressArray, useCurrentLocation: useCurrentLoc,
                waypointIsAddress:waypointIsAddr)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if (segue.identifier == "routeToMap")
        {
            let svc = segue.destinationViewController as! appleMapViewController
            svc.fromRouteOptionsTable = true
            svc.routeOptions = routeOptions
            svc.index = index
            
            svc.addressArray[startIndex] = addressArray[startIndex]
            svc.addressArray[stopIndex] = addressArray[stopIndex]
            svc.addressArray[wayPointIndex] = addressArray[wayPointIndex]
            
            
            if(useCurrentLoc)
            {
                svc.useCurrentLocation = true
            }
            if(waypointIsAddr)
            {
                svc.waypointIsAddress = true
            }
        }
        if (segue.identifier == "homeSegue")
        {
            let svc = segue.destinationViewController as! StartViewController
            svc.startStr = addressArray[startIndex]
            svc.finishStr = addressArray[stopIndex]
            svc.waypointStr = addressArray[wayPointIndex]
            svc.currLocBool = useCurrentLoc
            svc.waypointBool = waypointIsAddr
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
