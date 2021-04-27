//
//  HomeViewController.swift
//  cis195app
//
//  The main view of the application
//

import UIKit
import FirebaseAuth
import CoreLocation
import SwiftyJSON
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var collectionView: UICollectionView?
    private var locationManager : CLLocationManager?
    private var currLocation : CLLocation?
    let currUser = FirebaseAuth.Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Header
        collectionView.register(TodayInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayInfoHeaderCollectionReusableView.identifier)
        collectionView.register(SpacerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpacerCollectionReusableView.identifier)
        
        // App selector
        collectionView.register(ToDoCollectionViewCell.self, forCellWithReuseIdentifier: ToDoCollectionViewCell.identifier)
        collectionView.register(ClassesCollectionViewCell.self, forCellWithReuseIdentifier: ClassesCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAuthenticated()
        getUserLocation()
    }
    
    // MARK: - Functions
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let size = (self.view.width - 80)/2
        layout.itemSize = CGSize(width: size, height: size)
        
        return layout
    }
    
    private func isAuthenticated() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navView, animated: true)
            }
        }
    }
    
    private func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        
        locationManager?.startUpdatingLocation()
        collectionView?.reloadData()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            
            let toDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCollectionViewCell.identifier, for: indexPath) as! ToDoCollectionViewCell
            if let userEmail = self.currUser?.email {
                DBController.sharedDB.getUser(with: userEmail) { (user) in
                    if let usr = user {
                        DBController.sharedDB.getToDoCount(with: usr) { (num) in
                            if num >= 0 {
                                DispatchQueue.main.async {
                                    toDoCell.numToDos.text = "\(num)"
                                    //self.collectionView?.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            return toDoCell
        }
        
        let classesCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassesCollectionViewCell.identifier, for: indexPath) as! ClassesCollectionViewCell
        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.getClassesCount(with: usr) { (num) in
                        if num >= 0 {
                            DispatchQueue.main.async {
                                classesCell.numClasses.text = "\(num)"
                                //self.collectionView?.reloadData()
                            }
                        }
                    }
                }
            }
        }
        return classesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView();
        }
        
        if indexPath.section == 1 {
            let spacer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SpacerCollectionReusableView.identifier, for: indexPath) as! SpacerCollectionReusableView
            
            return spacer
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TodayInfoHeaderCollectionReusableView.identifier, for: indexPath) as! TodayInfoHeaderCollectionReusableView
        
        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DispatchQueue.main.async {
                        header.nameLabel.text = "Welcome, \(usr.firstName)!"
                        //self.collectionView?.reloadData()
                    }
                }
            }
        }
        
        if let loc = currLocation {
            let lat = String(format: "%.3f", loc.coordinate.latitude)
            let lng = String(format: "%.3f", loc.coordinate.longitude)
            AF.request("https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\(lng)&key=\(api_key)&units=I").responseJSON { (res) in
                if let val = res.value {
                    let json = JSON(val)
                    if let temp = json["data"][0]["temp"].float, let city = json["data"][0]["city_name"].string {
                        let tempInt = Int(temp)
                        print(tempInt)
                        DispatchQueue.global().async(execute: {
                            DispatchQueue.main.async {
                                header.weatherLabel.text = String(tempInt) + "°"
                                header.cityLabel.text = city
                                //collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                        }})
                        
                        
                    }
                }
            }
            
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.width, height: collectionView.height/2)
        }
        
        return CGSize(width: collectionView.width, height: collectionView.height/10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.item == 0) {
            // present classes
            let vc = ClassesViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navView, animated: true)
            }
        } else {
            // present to-do
            let vc = ToDoViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navView, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude.rounded()
            let lng = location.coordinate.longitude.rounded()
            
            if let currLocation = self.currLocation {
                let curr_lat = currLocation.coordinate.latitude.rounded()
                let curr_lng = currLocation.coordinate.longitude.rounded()
                
                if (!Double.equal(curr_lat, lat, precise: 0) || !Double.equal(curr_lng, lng, precise: 0)) {
                    self.currLocation = location
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            } else {
                self.currLocation = location
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
}

