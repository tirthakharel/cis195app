//
//  LoginViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        // TODO: put some constraints and UI stuff
        emailField.placeholder = "Email Address"
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let pwField = UITextField()
        pwField.autocapitalizationType = .none
        pwField.autocorrectionType = .no
        pwField.returnKeyType = .done
        // TODO: put some constraints and UI stuff
        pwField.placeholder = "Password"
        pwField.isSecureTextEntry = true
        return pwField
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log In", for:.normal)
        btn.backgroundColor = .link
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        emailField.frame = CGRect(x: 30,
                                  y: 20,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                     y: passwordField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapRegister() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        let regView = RegistrationViewController()
        regView.title = "Create New Account"
        navigationController?.pushViewController(regView, animated: true)
    }
    
    @objc private func didTapLoginButton() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let pw = passwordField.text,
              !email.isEmpty, !pw.isEmpty else {
                alertLoginError()
                return
              }
        
        // Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pw) { [weak self] (_, err) in
            guard let strongSelf = self else {
                return
            }
            
            guard err == nil else {
                print("ERROR LOGGING IN: \(err!)")
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    func alertLoginError() {
        let alert = UIAlertController(title: "Error", message: "Please provide email and password to Log In", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

// MARK: - Delegate Functions
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        
        return true
    }
}
