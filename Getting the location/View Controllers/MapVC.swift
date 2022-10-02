//
//  MainVC.swift
//  Getting the location
//
//  Created by RuslanS on 6/5/22.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private var locationManager:CLLocationManager?
    var userLatitude = 0.0
    var userLongitude = 0.0
    
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            
            globalUserLatitude = userLatitude
            globalUserLongitude = userLongitude
            
//            print(userLongitude)
//            print(userLatitude)
            
            let mapLocation = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: mapLocation, span: span)
            
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    @IBAction func yesButtonClicked() {
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
}
