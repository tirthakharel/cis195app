//
//  ClassPageViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class ClassPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var currClass: UserClass?
    public var currUser: FirebaseAuth.User?
    var tableView: UITableView?
    var asgtList: [Assignment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero)
        
        guard let tableView = tableView else {
            return
        }
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        let plusImg = UIImage(systemName: "plus.circle.fill")
        let button =  UIBarButtonItem(image: plusImg, style: .plain, target: self, action: #selector(addAssignment))
        button.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = button
        
        tableView.register(AssignmentTableViewCell.self, forCellReuseIdentifier: AssignmentTableViewCell.identifier)

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userEmail = self.currUser?.email, let currClass = self.currClass?.className {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.getAssignments(with: usr, class: currClass) { (assignmentList) in
                        self.asgtList = assignmentList
                        DispatchQueue.main.async {
                            self.tableView?.reloadData()
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asgtList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssignmentTableViewCell.identifier) as! AssignmentTableViewCell
        let assgt = asgtList[indexPath.item]
        cell.assgtLabel.text = assgt.name
        cell.priorityLabel.text = assgt.priorityString
        cell.priorityLabel.textColor = assgt.priorityColor
        cell.dateLabel.text = assgt.dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Assignments"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            let asgtToDelete : Assignment = (self?.asgtList[indexPath.item])!
            if let userEmail = self?.currUser?.email, let currClass = self?.currClass?.className {
                DBController.sharedDB.getUser(with: userEmail) { (user) in
                    if let usr = user {
                        DBController.sharedDB.deleteAssignment(with: usr, class: currClass, asgt: asgtToDelete) { (assignmentList) in
                            self?.asgtList = assignmentList
                            DispatchQueue.main.async {
                                self?.tableView?.reloadData()
                            }
                        }
                    }
                }
            }
        }
        trash.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    @objc func addAssignment() {
        let vc = NewAssignmentViewController()
        vc.currUser = currUser
        vc.currClass = currClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
