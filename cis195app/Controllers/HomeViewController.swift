//
//  HomeViewController.swift
//  cis195app
//
//  The main view of the application
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isAuthenticated = UserDefaults.standard.bool(forKey: "logged_in")
        if !isAuthenticated {
            let vc = LoginViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            present(navView, animated: false)
        }
    }


}

