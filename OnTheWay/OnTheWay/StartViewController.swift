//
//  StartViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate{
    var startStr: String = ""
    var finishStr: String = ""
    var waypointStr: String = ""
    var currLocBool: Bool = true
    var waypointBool: Bool = false

    @IBOutlet weak var OnTheWay: UIImageView!
    @IBOutlet weak var EnterStart: UITextField!
    @IBOutlet weak var EnterWayPoint: UITextField!
    @IBOutlet weak var EnterFinish: UITextField!
    @IBOutlet weak var CurrentLoc: UISwitch!
    @IBOutlet weak var waypointAsAddress: UISwitch!
    @IBOutlet weak var routeTableButton: UIButton!
    @IBAction func waypointSwitchEvent(sender: AnyObject)
    {
        if(waypointAsAddress.on) {
            routeTableButton.alpha = 0.4
            routeTableButton.enabled = false
        } else {
            routeTableButton.alpha = 1.0
            routeTableButton.enabled = true
        }
    }
    
    let startIndex = 0;
    let stopIndex = 1;
    let wayPointIndex = 2;
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        EnterStart.delegate = self
        EnterFinish.delegate = self
        EnterWayPoint.delegate = self
        
        if(!startStr.isEmpty) {
            EnterStart.text = startStr
        }
        if(!finishStr.isEmpty) {
            EnterFinish.text = finishStr
        }
        if(!waypointStr.isEmpty) {
            EnterWayPoint.text = waypointStr
        }
        CurrentLoc.on = currLocBool
        waypointAsAddress.on = waypointBool
        
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
        if (segue.identifier == "appleMapSegue")
        {
            let svc = segue.destinationViewController as! appleMapViewController
            svc.addressArray[startIndex] = EnterStart.text!
            svc.addressArray[stopIndex] = EnterFinish.text!
            svc.addressArray[wayPointIndex] = EnterWayPoint.text!
            if(CurrentLoc.on)
            {
                svc.useCurrentLocation = true
            }
            if(waypointAsAddress.on)
            {
                svc.waypointIsAddress = true
            }
            
            if(!waypointAsAddress.on) {
                svc.routeOptions = RouteOptions(addressArray: svc.addressArray, useCurrentLocation: svc.useCurrentLocation,
                    waypointIsAddress:false)
            }
        }
        
        if (segue.identifier == "routesSegue")
        {
            let svc = segue.destinationViewController as! RoutesViewController
            svc.addressArray[startIndex] = EnterStart.text!
            svc.addressArray[stopIndex] = EnterFinish.text!
            svc.addressArray[wayPointIndex] = EnterWayPoint.text!
            svc.useCurrentLoc = CurrentLoc.on
            svc.waypointIsAddr = waypointAsAddress.on
        }
       
    }

}
