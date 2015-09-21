//
//  MasterViewController.swift
//  RoadTripPlanner
//
//  Created by Carli Lessard on 9/6/15.
//  Copyright (c) 2015 CarliLessard. All rights reserved.
//

import UIKit
import GoogleMaps

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(34.1561,
            longitude: -118.1319, zoom: 9)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        // change map view type
        //mapView.mapType = kGMSTypeSatellite
        
        //var mapInsets = UIEdgeInsetsMake(100.0, 0.0, 0.0, 300.0)
        //mapView.padding = mapInsets
        
        mapView.myLocationEnabled = true
        self.view = mapView
        
        mapView.settings.compassButton = true
        
        mapView.settings.myLocationButton = true
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.85, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        var marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(-33.70, 151.40)
        marker2.title = "Sydney2"
        marker2.snippet = "Australia2"
        marker2.map = mapView
        
        var path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.0))
        path.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.0))
        path.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.2))
        path.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.2))
        path.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.0))
        
        var rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
        
        var start = GMSMarker()
        start.position = CLLocationCoordinate2DMake(34.1100, -117.7197)
        start.title = "Claremont"
        start.snippet = "California"
        start.map = mapView
        
        var end = GMSMarker()
        end.position = CLLocationCoordinate2DMake(34.0219, -118.4814)
        end.title = "Santa Monica"
        end.snippet = "California"
        end.map = mapView
        
        var stop1 = GMSMarker()
        stop1.position = CLLocationCoordinate2DMake(34.4238, -118.5971)
        stop1.title = "Six FLags"
        stop1.snippet = "California"
        stop1.map = mapView
        
        var stop2 = GMSMarker()
        stop2.position = CLLocationCoordinate2DMake(34.1561, -118.1319)
        stop2.title = "Pasadena"
        stop2.snippet = "California"
        stop2.map = mapView
        
        var stop3 = GMSMarker()
        stop3.position = CLLocationCoordinate2DMake(33.8003, -117.8828)
        stop3.title = "Angels Stadium"
        stop3.snippet = "California"
        stop3.map = mapView
        
        var path1 = GMSMutablePath()
        path1.addCoordinate(start.position)
        path1.addCoordinate(stop1.position)
        path1.addCoordinate(end.position)
        var startStop1 = start.position
        
        var path2 = GMSMutablePath()
        path2.addCoordinate(start.position)
        path2.addCoordinate(stop2.position)
        path2.addCoordinate(end.position)
        
        var path3 = GMSMutablePath()
        path3.addCoordinate(start.position)
        path3.addCoordinate(stop3.position)
        path3.addCoordinate(end.position)
        
        var stops = [stop1,stop2,stop3]
        
        var paths = [path1,path2,path3]
        
        /*
        Calculates min path and returns lists that will be used for user selection page
        */
        func GetMinPath(inout paths: [GMSMutablePath],inout stops: [GMSMarker],start: GMSMarker,end: GMSMarker) -> ([GMSMutablePath],[Double],[Double],[Double],Double){
            
            var minPath = GMSMutablePath()
            
            func MINPATH(paths: [GMSMutablePath],stops: [GMSMarker]) -> (Double , GMSMutablePath){
                var minDist = 1000000000.0
                var minPath = GMSMutablePath()
                for var index = 0; index < paths.count; ++index {
                    var xDist1 = start.position.latitude - stops[index].position.latitude
                    var yDist1 = start.position.longitude - stops[index].position.longitude
                    var xDist2 = end.position.latitude - stops[index].position.latitude
                    var yDist2 = end.position.longitude - stops[index].position.longitude
                    var totalDistance = sqrt(pow(xDist1,2) + pow(yDist1,2)) + sqrt(pow(xDist2,2) + pow(yDist2,2))
                    if minDist > totalDistance{
                        minDist = totalDistance
                        minPath = paths[index]
                    }
                }
                return (minDist,minPath)
            }
            
            var minPaths = [GMSMutablePath]()
            
            var minDists = [Double]()
            
            var minDist = 0.0
            
            while(paths.count != 0){
                (minDist,minPath) = MINPATH(paths, stops)
                minPaths.append(minPath)
                minDists.append(minDist)
                println(minDists)
                var tempPaths = [GMSMutablePath] ()
                var tempStops = [GMSMarker] ()
                for var i = 0; i < paths.count; ++i {
                    if (paths[i] != minPath){
                        tempPaths.append(paths[i])
                        tempStops.append(stops[i])
                    }
                }
                paths = tempPaths
                stops = tempStops
            }
            
            minPath = minPaths[0]
            
            var xDist = start.position.latitude - end.position.latitude
            var yDist = start.position.longitude - end.position.longitude
            
            
            var totalTime = [Double] ()
            var timeAdded = [Double] ()
            var STARTtoSTOP = sqrt(pow(xDist,2) + pow(yDist,2))
            for var i = 0; i < minPaths.count; ++i {
                totalTime.append(minDists[i])
                timeAdded.append(minDists[i] - STARTtoSTOP)
            }
            
            return (minPaths,minDists,totalTime,timeAdded,STARTtoSTOP)
        }
        var minPaths = [GMSMutablePath]()
        var minDists = [Double]()
        var totalTime = [Double]()
        var timeAdded = [Double]()
        var STARTtoSTOP = 0.0
        (minPaths,minDists,totalTime,timeAdded,STARTtoSTOP) = GetMinPath(&paths,&stops,start,end)
        var minimumPath = GMSPolyline(path: minPaths[0])
        minimumPath.map = mapView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

