//
//  ViewController.swift
//  Getting the location
//
//  Created by RuslanS on 6/5/22.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var locationManager:CLLocationManager?
    
    var userLatitude = 0.0              //Sets user coordinates to 0 when launching
    var userLongitude = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "Key") == true{
            performSegue(withIdentifier: "straightToMain", sender: nil)
        }
        
        locationManager = CLLocationManager()                       //Creates location manager
        locationManager?.requestAlwaysAuthorization()               //Requests location always from location manager
        locationManager?.delegate = self                            //Sets location manager delegate to self
        locationManager?.startUpdatingLocation()                    //Starts updating the location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLatitude = location.coordinate.latitude                                 //Sets userLatitude to user's location
            userLongitude = location.coordinate.longitude                               //Sets userLongitude to user's location
            
            globalUserLatitude = userLatitude
            globalUserLongitude = userLongitude
        }
    }

    @IBAction func buttonClicked(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "Key") == true {
            performSegue(withIdentifier: "straightToMain", sender: nil)                     //Checks if user has already done the "verify location on map" step, if yes goes straight to main page
        } else {
            performSegue(withIdentifier: "toMapVC", sender: nil)                            //Goes to the next screen when button is clicked
        }
    }
}

