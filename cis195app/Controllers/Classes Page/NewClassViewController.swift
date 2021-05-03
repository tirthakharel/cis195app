//
//  NewClassViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class NewClassViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickerData = ["White", "Blue", "Red", "Light Gray", "Green", "Yellow"]
    var pickedIdx = 0
    var currUser: FirebaseAuth.User?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.colorTextField.text = pickerData[row]
        self.pickedIdx = row
        colorPicker.resignFirstResponder()
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let nameField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.placeholder = "Class Name"
        emailField.borderStyle = .roundedRect
        return emailField
    }()
    
    private let colorPicker: UIPickerView = {
        let priorityField = UIPickerView()
        return priorityField
    }()
    
    private let colorTextField : UITextField = {
        let pickerField = UITextField()
        pickerField.placeholder = "Color"
        pickerField.borderStyle = .roundedRect
        return pickerField
    }()
    
    private let submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Class", for:.normal)
        btn.backgroundColor = .systemGreen
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Class"
        view.backgroundColor = .white
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        nameField.delegate = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        colorTextField.inputView = colorPicker
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(colorTextField)
        scrollView.addSubview(submitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        nameField.frame = CGRect(x: 30,
                                 y: 20,
                                 width: scrollView.width - 60,
                                 height: 52)
        
        colorTextField.frame = CGRect(x: 30,
                                       y: nameField.bottom + 10,
                                       width: scrollView.width - 60,
                                       height: 52)
        
        submitButton.frame = CGRect(x: 30,
                                    y: colorTextField.bottom + 10,
                                    width: scrollView.width - 60,
                                    height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSubmitButton() {
        nameField.resignFirstResponder()
        colorTextField.resignFirstResponder()
        guard let className = nameField.text, let colorStr = colorTextField.text,
              !className.isEmpty, !colorStr.isEmpty else {
            alertSubmitError(with: "Please provide all fields")
                return
              }

        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.addClass(with: usr, with: UserClass(className: className, bgValue: self.pickedIdx, assignments: [])) { (succ, err) in
                        if (succ) {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.alertSubmitError(with: err!)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func alertSubmitError(with err : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

// MARK: - Delegate Functions
extension NewClassViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameField {
            colorTextField.becomeFirstResponder()
        } else if textField == colorTextField {
            didTapSubmitButton()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == colorTextField {
            colorPicker.isHidden = false
            return false
        }
        return true
    }
}
