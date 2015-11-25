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
    
    var routes = [String]()
    
    
    @IBOutlet weak var routesTableView: UITableView!    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableViewCell
        
        let row = indexPath.row
        cell.tableCellData.text = routes[row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routesTableView.delegate = self
        routesTableView.dataSource = self

        routes = [startAddress, wayPointAddress, stopAddress]
        
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
