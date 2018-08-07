//
//  LocationManager.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//
import UIKit
import CoreLocation

class LocationManager : NSObject,CLLocationManagerDelegate {
    public static let sharedInstance = LocationManager()
    public var delegate : LocationDelegate?
    public var notDetermined: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    lazy public var locationManager : CLLocationManager = {
        
        let _locationManager = CLLocationManager()
        
        _locationManager.distanceFilter = 5
        _locationManager.delegate = self
        _locationManager.requestAlwaysAuthorization()
        
        return _locationManager
    }()
    
    public func startLocationUpdate() {
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.startUpdatingLocation()
    }
    
    public func hasPermission() -> Bool {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    public func getLastKnowLocation() -> CLLocation? {
        return self.locationManager.location
    }
    
    public func requestPermission() {
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    public func alertGPS() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Cocos", message: "El GPS está desactivado ¿deseas activarlo?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default) { (alert) in
            
            var url: URL?
            
            if !CLLocationManager.locationServicesEnabled()
            {
                // Works in ios 10
                url = URL(string: "App-Prefs:root=Privacy&path=LOCATION")
            }
            else
            {
                url = URL(string: UIApplicationOpenSettingsURLString)
            }
            
            guard url != nil else {
                
                return
            }
            
            if UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: ["":""], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        })
        
        return alertController
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let ubication = locations.first
        {
            //            self.locationManager.stopUpdatingLocation()
            
            self.delegate?.getLocation(coord: ubication.coordinate)
            //            self.delegado = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error fetching user's location")
    }
    
}
