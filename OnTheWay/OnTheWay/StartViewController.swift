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
    // MARK: Properties
    //@IBOutlet weak var startTextField: UITextField!
    //@IBOutlet weak var waypointTextField: UITextField!
    //@IBOutlet weak var finishTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "mapSegue") {
            //println("preparing for segue");
            var svc = segue.destinationViewController as! ViewController;
            println(EnterStart.text);
            svc.address = EnterStart.text;
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
