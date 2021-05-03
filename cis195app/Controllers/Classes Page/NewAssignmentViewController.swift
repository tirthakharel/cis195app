//
//  NewAssignmentViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class NewAssignmentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickerData = ["(!) Low Priority", "(!!) Medium Priority", "(!!!) High Priority"]
    var pickedIdx = 0
    var currUser: FirebaseAuth.User?
    var currClass: UserClass?
    
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
        self.priorityTextField.text = pickerData[row]
        self.pickedIdx = row + 1
        priorityPicker.resignFirstResponder()
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
        emailField.placeholder = "Assignment Name"
        emailField.borderStyle = .roundedRect
        return emailField
    }()
    
    private let priorityPicker: UIPickerView = {
        let priorityField = UIPickerView()
        return priorityField
    }()
    
    private let priorityTextField : UITextField = {
        let pickerField = UITextField()
        pickerField.placeholder = "Priority"
        pickerField.borderStyle = .roundedRect
        return pickerField
    }()
    
    private let dateTextField : UITextField = {
        let pickerField = UITextField()
        pickerField.placeholder = "Due Date (Optional)"
        pickerField.borderStyle = .roundedRect
        return pickerField
    }()
    
    private let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private let submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Assignment", for:.normal)
        btn.backgroundColor = .systemGreen
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Assignment"
        view.backgroundColor = .white
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        nameField.delegate = self
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        priorityTextField.inputView = priorityPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeDP))
        toolbar.setItems([doneBtn], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
        view.addSubview(scrollView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(priorityTextField)
        scrollView.addSubview(dateTextField)
        scrollView.addSubview(submitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        nameField.frame = CGRect(x: 30,
                                 y: 20,
                                 width: scrollView.width - 60,
                                 height: 52)
        
        priorityTextField.frame = CGRect(x: 30,
                                       y: nameField.bottom + 10,
                                       width: scrollView.width - 60,
                                       height: 52)
        
        dateTextField.frame = CGRect(x: 30,
                                       y: priorityTextField.bottom + 10,
                                       width: scrollView.width - 60,
                                       height: 52)
        
        submitButton.frame = CGRect(x: 30,
                                    y: dateTextField.bottom + 10,
                                    width: scrollView.width - 60,
                                    height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSubmitButton() {
        nameField.resignFirstResponder()
        priorityTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        guard let taskName = nameField.text, let priority = priorityTextField.text,
              !taskName.isEmpty, !priority.isEmpty else {
            alertSubmitError(with: "Please provide all required fields")
            return
        }
        
        guard let className = currClass?.className else {
            alertSubmitError(with: "Class not present")
            return
        }

        if let userEmail = self.currUser?.email {
            let dateText = self.dateTextField.text == "" ? nil : self.dateTextField.text
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                        DBController.sharedDB.addAssignment(with: usr, class: className, assgt: Assignment(name: taskName, priority: self.pickedIdx, dueDate: dateText)) { (succ, err) in
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
    
    @objc func closeDP() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        self.dateTextField.text = dateFormat.string(from: datePicker.date)
        self.view.endEditing(true)
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
extension NewAssignmentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameField {
            priorityTextField.becomeFirstResponder()
        } else if textField == priorityTextField {
            didTapSubmitButton()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == priorityTextField {
            priorityPicker.isHidden = false
            return false
        }
        return true
    }
}
