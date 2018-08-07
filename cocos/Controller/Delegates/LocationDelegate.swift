//
//  LocationDelegate.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import CoreLocation

protocol LocationDelegate : class {
    func getLocation(coord: CLLocationCoordinate2D)
}
