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
    @IBOutlet weak var waypointAsAddress: UISwitch!
    
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
        super.viewDidLoad()
        
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
        }
        
        if (segue.identifier == "routesSegue")
        {
            let svc = segue.destinationViewController as! RoutesViewController
            svc.startAddress = EnterStart.text!
            svc.stopAddress = EnterFinish.text!
            svc.wayPointAddress = EnterWayPoint.text!
        }
       
    }

}
