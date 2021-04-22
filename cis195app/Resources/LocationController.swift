//
//  LocationController.swift
//  cis195app
//
//  Created by Tirtha Kharel on 4/21/21.
//

import Foundation
import CoreLocation

final class LocationController {
    static let locManager = CLLocationManager()
    
    static func hasLocationAccess() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}

