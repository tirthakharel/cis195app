//
//  DBController.swift
//  cis195app
//
//  For database management
//

import Foundation
import FirebaseDatabase

final class DBController {
    static let sharedDB = DBController()
    
    private let db = Database.database().reference()
}

// MARK: - User Functions
extension DBController {
    
    public func doesUserExist(with email: String, completion: @escaping ((Bool) -> Void)) {
        print("whatttt")
        
        var escapedEmail = email.replacingOccurrences(of: ".", with: "-")
        escapedEmail = escapedEmail.replacingOccurrences(of: "@", with: "-")
        
        db.child(escapedEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard let _ = snapshot.value as? String else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    /// Inserts new user into database
    public func insertUser(with user: User) {
        db.child(user.escapedEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
    
    public func getUser(with rawEmail: String, completion: @escaping ((User?) -> Void)){
        db.child(rawEmail.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")).getData { (err, data) in
            guard err == nil else {
                completion(nil)
                return
            }
            
            if let dataMap = data.value as? NSDictionary {
                if let firstName = dataMap["first_name"] as! String?, let lastName = dataMap["last_name"] as! String? {
                    completion(User(firstName: firstName, lastName: lastName, emailAddr: rawEmail))
                } else {
                    print("First name, last name doesn't exist?")
                }
            } else {
                completion(nil)
            }
        }
    }
    
    /// Gets number of classes registered
    public func getClassesCount(with user: User, completion: @escaping ((Int) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion(-1)
                return
            }
            
            if let dataMap = data.value as! NSDictionary? {
                let dict: NSDictionary = dataMap
                if let classes = dict["classes"] as! NSArray? {
                    completion(classes.count)
                } else {
                    completion(0)
                }
            } else {
                completion(-1)
            }
        }
    }
    
    /// Gets number of to-dos registered
    public func getToDoCount(with user: User, completion: @escaping ((Int) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion(-1)
                return
            }
            
            if let dataMap = data.value as! NSDictionary? {
                let dict: NSDictionary = dataMap
                if let todos = dict["todos"] as? NSArray {
                    completion(todos.count)
                } else {
                    completion(0)
                }
            } else {
                completion(-1)
            }
        }
    }
    
    
    /// Gets list of to-dos
    public func getToDos(with user: User, completion: @escaping (([ToDo]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var toDoArr: [ToDo] = []
            
            if let dataMap = data.value as? NSDictionary {
                if let todo = dataMap["todos"] as? NSArray {
                    for item in todo {
                        if let todoItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let taskName = todoItem["task"] as! String
                            let priority = todoItem["priority"] as! Int
                            toDoArr.append(ToDo(taskName: taskName, priority: priority, dueDate: nil))
                        }
                    }
                    completion(toDoArr)
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
    
    /// Adds new to-do
    public func addToDo(with user: User, with toDoToAdd: ToDo, completion: @escaping ((Bool) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion(false)
                return
            }
            
            if let dataMap = data.value as? NSDictionary {
                let newToDo : NSDictionary = [ "task" : toDoToAdd.taskName, "priority" : toDoToAdd.priority]
                if let todos = dataMap["todos"] as? NSMutableArray {
                    todos.add(newToDo)
                    self.db.child("\(user.escapedEmail)/todos").setValue(todos)
                    completion(true)
                } else {
                    let arr : NSArray = [newToDo]
                    self.db.child("\(user.escapedEmail)/todos").setValue(arr)
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    /// Deletes to-do
    public func removeToDo(with user: User, with toDoToDelete: ToDo, completion: @escaping (([ToDo]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var toDoArr: [ToDo] = []
            var removed = false
            let updatedToDos : NSMutableArray = []
            
            if let dataMap = data.value as? NSDictionary {
                if let todos = dataMap["todos"] as? NSMutableArray {
                    for item in todos {
                        if let todoItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let taskName = todoItem["task"] as! String
                            let priority = todoItem["priority"] as! Int
                            if taskName != toDoToDelete.taskName || priority != toDoToDelete.priority || removed {
                                toDoArr.append(ToDo(taskName: taskName, priority: priority, dueDate: nil))
                                updatedToDos.add(item)
                            } else {
                                removed.toggle()
                            }
                        }
                    }
                    self.db.child("\(user.escapedEmail)/todos").setValue(updatedToDos)
                    completion(toDoArr)
                }
            } else {
                completion([])
            }
        }
    }
}
