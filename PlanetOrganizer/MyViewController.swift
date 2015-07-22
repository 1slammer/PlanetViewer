//
//  ViewController.swift
//  PlanetOrganizer
//
//  Created by Jeffrey Nolen on 7/21/15.
//  Copyright (c) 2015 Jeffrey Nolen. All rights reserved.
//

import UIKit
import CoreLocation

class MyViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{
    private var cellPointSize: CGFloat!
    private let dataCell = "Data"
    var dataGetter:NavalDataGetter!
    var dataGetter2:NavalDataGetter!
    var orderedVals = Array<Array<Double>>()
    var orderedVals2 = Array<Array<Double>>()
    var moonstringTimes = [String]()
    var sunstringTimes = [String]()
    var locationManager: CLLocationManager! = CLLocationManager()
    var location: CLLocation!
    var hasUpdated = false
    
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        //Can set a filter on how often the updates happen
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.startUpdatingLocation()
        //Set the device orientation for purposes of heading updates
        //while location == nil {
                //sleep(1)
        //}

//        dataGetter = NavalDataGetter(bodyIn: "Moon", location: location)
//        dataGetter2 = NavalDataGetter(bodyIn: "Sun", location: location)
//        while !dataGetter.isFinished {
//            sleep(1)
//        }
//        while !dataGetter2.isFinished {
//            sleep(1)
//        }
//        self.moonstringTimes = dataGetter.stringTimes
//        self.sunstringTimes = dataGetter.stringTimes
//        self.orderedVals = dataGetter.orderedVals
//        self.orderedVals2 = dataGetter2.orderedVals
//
        
        let preferredTableViewFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cellPointSize = preferredTableViewFont.pointSize
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 0 ? orderedVals.count : orderedVals2.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Moon Data" : "Sun Data"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(dataCell, forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text =  moonstringTimes[indexPath.row]
            var y = String(format : "%f", orderedVals[indexPath.row][0])
            var z = String(format : "%f", orderedVals[indexPath.row][1])
            var x = "Azimuth: " + y + "Altitude: " + z

            cell.detailTextLabel?.text = x
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(dataCell, forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text =  sunstringTimes[indexPath.row]
            var y = String(format : "%f", orderedVals2[indexPath.row][0])
            var z = String(format : "%f", orderedVals2[indexPath.row][1])
            var x = "Azimuth: " + y + "Altitude: " + z
            
            cell.detailTextLabel?.text = x
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //albumsList.removeAlbum(indexPath.row)
            myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
        
    }
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!) {
            // Just want the one location check, so get it and turn the updates off
            if (!hasUpdated){
                hasUpdated = true
                location = locations.last as! CLLocation
                dataGetter = NavalDataGetter(bodyIn: "Moon", location: location)
                dataGetter2 = NavalDataGetter(bodyIn: "Sun", location: location)
                while !dataGetter.isFinished {
                    sleep(1)
                }
                while !dataGetter2.isFinished {
                    sleep(1)
                }
                self.moonstringTimes = dataGetter.stringTimes
                self.sunstringTimes = dataGetter.stringTimes
                self.orderedVals = dataGetter.orderedVals
                self.orderedVals2 = dataGetter2.orderedVals
                self.myTableView.reloadData()
                

                
            } else {
                locationManager.stopUpdatingLocation()
            }
            
    }
    // Delegate error handler
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!)
    {
        println("Error getting location.")
        // Set up and present an alert if location updates are not turned on
        let settingsAction: UIAlertAction = UIAlertAction(title: "Go to Settings", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            var appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(appSettings!)
        }
        let alert = UIAlertController(title: "Alert", message: "You must have location updates enabled to use this App.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(settingsAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }


    
//    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        albumsList.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
//    }
//    
    
    
}

