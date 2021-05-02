//
//  NewToDoViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class NewToDoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerData = ["(!) Low Priority", "(!!) Medium Priority", "(!!!) High Priority"]
    let selectData = ["1", "2", "3"]
    var currUser: FirebaseAuth.User?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerTextField.text = selectData[row]
        priorityField.resignFirstResponder()
    }
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let taskField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.placeholder = "Task Name"
        return emailField
    }()
    
    private let priorityField: UIPickerView = {
        let priorityField = UIPickerView()
        return priorityField
    }()
    
    private let pickerTextField : UITextField = {
        let pickerField = UITextField()
        pickerField.placeholder = "Priority"
        return pickerField
    }()
    
    private let submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for:.normal)
        btn.backgroundColor = .link
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New To-Do"
        view.backgroundColor = .white
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        taskField.delegate = self
        priorityField.delegate = self
        priorityField.dataSource = self
        pickerTextField.text = selectData[0]
        pickerTextField.inputView = priorityField
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(taskField)
        scrollView.addSubview(pickerTextField)
        scrollView.addSubview(submitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        taskField.frame = CGRect(x: 30,
                                 y: 20,
                                 width: scrollView.width - 60,
                                 height: 52)
        
        pickerTextField.frame = CGRect(x: 30,
                                       y: taskField.bottom + 10,
                                       width: scrollView.width - 60,
                                       height: 52)
        
        submitButton.frame = CGRect(x: 30,
                                    y: pickerTextField.bottom + 10,
                                    width: scrollView.width - 60,
                                    height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSubmitButton() {
        taskField.resignFirstResponder()
        pickerTextField.resignFirstResponder()
        guard let task = taskField.text, let priorityStr = pickerTextField.text,
              !task.isEmpty, let priority = Int(priorityStr) else {
                alertSubmitError()
                return
              }

        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.addToDo(with: usr, with: ToDo(taskName: task, priority: priority, dueDate: nil)) { succ in
                        if (succ) {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.alertSubmitError()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func alertSubmitError() {
        let alert = UIAlertController(title: "Error", message: "Please provide all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

// MARK: - Delegate Functions
extension NewToDoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == taskField {
            pickerTextField.becomeFirstResponder()
        } else if textField == pickerTextField {
            didTapSubmitButton()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pickerTextField {
            priorityField.isHidden = false
            return false
        }
        return true
    }
}

