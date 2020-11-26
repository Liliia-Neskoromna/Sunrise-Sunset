//
//  ViewController.swift
//  SunsetSunrise
//
//  Created by Liliia Neskoromna on 20.11.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {

    var sunInfoVC: SunInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
    }
    
    let manager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    var sunrise: String = ""
    var sunset: String = ""
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
//        print(location.coordinate.latitude)
            
//        lat.text = String(describing: self.latitude)
//        long.text = String(describing: self.longitude)
        
        NetworkService.sharedNetworkService.loadData(completion: { sunInfo in
            
            self.sunInfoVC = sunInfo
            
        }, lat: latitude, long: longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

