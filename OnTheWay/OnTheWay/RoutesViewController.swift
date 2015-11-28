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
        return routes.count
    }
    
    // Fills the table with the information from routes array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableViewCell
        
        let row = indexPath.row
        cell.tableCellData.text = routes[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        index = indexPath.row
        
        //performSegueWithIdentifier("routeToMap", sender: self)
    }
    
    // Loads the display
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routesTableView.delegate = self
        routesTableView.dataSource = self

        // Calculate the waypoint options
        routeOptions = RouteOptions(addressArray: addressArray, useCurrentLocation: useCurrentLoc,
            waypointIsAddress:waypointIsAddr)
        
        // Fills in the table with the top 10 choices of waypoints
        var tableSize = 10
        if(routeOptions.waypointOptions.count < 11){
            tableSize = routeOptions.waypointOptions.count
        }
        for var i = 0; i < tableSize; ++i{
            routes.append("\(routeOptions.waypointOptions[i].getAddress())")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if (segue.identifier == "routeToMap")
        {
            print("Moving from table to Map")
            let svc = segue.destinationViewController as! appleMapViewController
            svc.fromRouteOptionsTable = true
            svc.routeOptions = routeOptions
            print("index: \(index)")
            svc.index = index
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
