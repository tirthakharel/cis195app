//
//  HomeViewController.swift
//  cis195app
//
//  The main view of the application
//

import UIKit
import FirebaseAuth
import CoreLocation

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    static var currUser: User? // the current user in the application (need static so we can access from other parts)
    let locationManager = CLLocationManager()
    
    let toDoConfig = UICollectionView.CellRegistration<ToDoCollectionViewCell, String> { (cell, indexPath, model) in
        // TODO: all user =
//        DBController.sharedDB.getClassesCount(with: FirebaseAuth.Auth.auth().currentUser) { (<#Int#>) in
//            <#code#>
//        }
        cell.label.text = model
    }
//    let classesConfig = UICollectionView.CellRegistration<ClassesCollectionViewCell, String> { (cell, indexPath, model) in
//        cell.label.text = model
//    }

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAuthenticated()
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
            present(navView, animated: false)
        } else {
            let user = FirebaseAuth.Auth.auth().currentUser!
            if let email = user.email {
                DBController.sharedDB.getUser(with: email) { (usr) in
                    HomeViewController.currUser = usr
                }
            } else {
                let vc = LoginViewController()
                let navView = UINavigationController(rootViewController: vc)
                navView.modalPresentationStyle = .fullScreen
                present(navView, animated: false)
            }
        }
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
            
            let model = "To Do Cell"
            
            let toDoCell = collectionView.dequeueConfiguredReusableCell(using: toDoConfig, for: indexPath, item: model)
            return toDoCell
        }
        
        let classesCell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCollectionViewCell.identifier, for: indexPath)
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

}

extension HomeViewController: CLLocationManagerDelegate {
    
}

