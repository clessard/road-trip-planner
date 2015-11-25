//
//  StartViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var OnTheWay: UIImageView!
    @IBOutlet weak var EnterStart: UITextField!
    @IBOutlet weak var EnterWayPoint: UITextField!
    @IBOutlet weak var EnterFinish: UITextField!
    @IBOutlet weak var CurrentLoc: UISwitch!
    
    let startIndex = 0;
    let stopIndex = 1;
    let wayPointIndex = 2;
    
    /*
    @IBAction func buttonClicked(sender: AnyObject)
    {
        if useCurrentLoc.on {
            
            useCurrentLoc.setOn(false, animated:true)
        } else {
        
            useCurrentLoc.setOn(true, animated:true)
        }
    }
    */
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        print("loading view")
        super.viewDidLoad()
        print("loaded super view")
        
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        print("entered segue")
        //if the user wants a map
        if (segue.identifier == "mapSegue")
        {
            print("hit map segue")
            let svc = segue.destinationViewController as! ViewController
            print("entering important info")
            svc.addressArray[startIndex] = EnterStart.text!
            print("entered 1")
            svc.addressArray[stopIndex] = EnterFinish.text!
            print("entered 2")
            svc.addressArray[wayPointIndex] = EnterWayPoint.text!
            print("entered 3")
            
            
            if(CurrentLoc.on)
            {
                print("turned current loc on")
                svc.useCurrentLocation = true
                print("done turning on")
            }

        }
        if (segue.identifier == "appleMapSegue")
        {
            print("hit map segue")
            let svc = segue.destinationViewController as! appleMapViewController
            print("entering important info")
            svc.addressArray[startIndex] = EnterStart.text!
            print("entered 1")
            svc.addressArray[stopIndex] = EnterFinish.text!
            print("entered 2")
            svc.addressArray[wayPointIndex] = EnterWayPoint.text!
            print("entered 3")
            
            
            if(CurrentLoc.on)
            {
                print("turned current loc on")
                svc.useCurrentLocation = true
                print("done turning on")
            }

        }
        
        if (segue.identifier == "routesSegue")
        {
            print("hit routes segue")
            let svc = segue.destinationViewController as! RoutesViewController
            svc.startAddress = EnterStart.text!
            print("entered 1")
            svc.stopAddress = EnterFinish.text!
            print("entered 2")
            svc.wayPointAddress = EnterWayPoint.text!
        }
        
       
    }
    
    // MARK: Actions
    //@IBAction func getDirections(sender: UIButton) {
    //    var directions = "https://maps.googleapis.com/maps/api/directions/json?origin="
    //    directions += startTextField.text
    //    directions += "&destination="
    //    directions += finishTextField.text
    //    directions += "&waypoints="
    //    directions += waypointTextField.text
    //    directions += "&key=AIzaSyALDVeOjIjUNIS6nXqmQ03PRZZqM6kmQUg"
    //}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
