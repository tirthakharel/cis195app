//
//  TodayInfoHeaderCollectionReusableView.swift
//  cis195app
//

import UIKit
import CoreLocation

class TodayInfoHeaderCollectionReusableView: UICollectionReusableView, CLLocationManagerDelegate {
    static let identifier = "TodayInfoHeaderView"
    private let locManager = LocationController.locManager;
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.text = "Welcome, ____!"
        label.textColor = .black
        return label
    }()
    
    let cityLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .darkGray
        label.text = "---------"
        return label
    }()
    
    let weatherLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 150, weight: .bold)
        label.textColor = .black
        label.text = "-"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        print("jhgjh")
        
        self.addSubview(nameLabel)
        self.addSubview(cityLabel)
        self.addSubview(weatherLabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 20, y: 25, width: self.width, height: 30)
        cityLabel.frame = CGRect(x: 20, y: nameLabel.bottom + 10, width: self.width, height: 20)
        weatherLabel.frame = CGRect(x: 20, y: cityLabel.bottom + 10, width: self.width, height: 150)
    }
}
