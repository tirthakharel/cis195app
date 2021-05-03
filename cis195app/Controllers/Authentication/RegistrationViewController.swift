//
//  RegistrationViewController.swift
//  cis195app
//
//  Created by Tirtha Kharel on 4/17/21.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let firstNameField: UITextField = {
        let firstNameField = UITextField()
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .continue
        firstNameField.borderStyle = .roundedRect
        firstNameField.placeholder = "First Name"
        return firstNameField
    }()
    
    private let lastNameField: UITextField = {
        let lastNameField = UITextField()
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .continue
        lastNameField.borderStyle = .roundedRect
        lastNameField.placeholder = "Last Name"
        return lastNameField
    }()
    
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.borderStyle = .roundedRect
        emailField.placeholder = "example@email.com"
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let pwField = UITextField()
        pwField.autocapitalizationType = .none
        pwField.autocorrectionType = .no
        pwField.returnKeyType = .done
        pwField.borderStyle = .roundedRect
        pwField.placeholder = "Password"
        pwField.isSecureTextEntry = true
        return pwField
    }()
    
    private let confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for:.normal)
        btn.backgroundColor = .systemGreen
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .white
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(confirmButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        firstNameField.frame = CGRect(x: 30,
                                      y: 20,
                                      width: scrollView.width - 60,
                                      height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        confirmButton.frame = CGRect(x: 30,
                                     y: passwordField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapConfirmButton() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let pw = passwordField.text, let first = firstNameField.text, let last = lastNameField.text,
              !email.isEmpty, !pw.isEmpty, !first.isEmpty, !last.isEmpty else {
            alertRegistrationError()
            return
        }
        
        DBController.sharedDB.doesUserExist(with: email) { [weak self] (exists) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                strongSelf.alertRegistrationError("User with that email already exists!")
                return
            }
            
            // Firebase Registration
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pw) { (authResult, err) in
                
                guard authResult != nil, err == nil else {
                    print("ERROR CREATING THE USER")
                    return
                }
                
                DBController.sharedDB.insertUser(with: User(firstName: first, lastName: last, emailAddr: email))
                
                if let presenter = strongSelf.presentingViewController as? HomeViewController {
                    presenter.collectionView?.reloadData()
                }
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Functions
    
    func alertRegistrationError(_ message: String = "Please fill out all fields!") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

// MARK: - Delegate Functions
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameField {
            firstNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapConfirmButton()
        }
        
        return true
    }
}
