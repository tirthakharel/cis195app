//
//  HomeViewController.swift
//  cis195app
//
//  The main view of the application
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAuthenticated()
    }
    
    // MARK: - Functions
    
    private func isAuthenticated() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            present(navView, animated: false)
        } else {
            //print("USER: \(FirebaseAuth.Auth.auth().currentUser)")
        }
    }


}

