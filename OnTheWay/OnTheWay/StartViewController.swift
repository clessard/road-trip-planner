//
//  StartViewController.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/20/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var EnterStart: UITextField!
    @IBOutlet weak var EnterWayPoint: UITextField!
    @IBOutlet weak var EnterFinish: UITextField!
    @IBOutlet weak var useCurrentLoc: UISwitch!
    
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "mapSegue") {
            //println("preparing for segue");
            let svc = segue.destinationViewController as! ViewController
            print(EnterStart.text, terminator: "")
            svc.startAddress = EnterStart.text!
            svc.stopAddress = EnterFinish.text!
            svc.wayPointAddress = EnterWayPoint.text!
            svc.useCurrentLocation = useCurrentLoc.on
        }
        else if (segue.identifier == "routesSegue") {
            let svc = segue.destinationViewController as! RoutesViewController;
            svc.startAddress = EnterStart.text!;
            svc.stopAddress = EnterFinish.text!;
            svc.wayPointAddress = EnterWayPoint.text!;
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
