//
//  TodayInfoHeaderCollectionReusableView.swift
//  cis195app
//

import UIKit
import CoreLocation

class TodayInfoHeaderCollectionReusableView: UICollectionReusableView, CLLocationManagerDelegate {
    static let identifier = "TodayInfoHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        LocationController.locManager.requestAlwaysAuthorization()
        LocationController.locManager.requestWhenInUseAuthorization()
        
        LocationController.locManager.delegate = self
        LocationController.locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.locationServicesEnabled() {
            LocationController.locManager.startUpdatingLocation()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
    }
}
