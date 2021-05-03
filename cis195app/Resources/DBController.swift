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
    
    /// Gets list of classes
    public func getClasses(with user: User, completion: @escaping (([UserClass]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var classArr: [UserClass] = []
            
            if let dataMap = data.value as? NSDictionary {
                if let classes = dataMap["classes"] as? NSArray {
                    for item in classes {
                        if let classItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let className = classItem["className"] as! String
                            let bgColor = classItem["bgValue"] as! Int
                            var asgtArr: [Assignment] = []
                            if let assgts = classItem["assignments"] as? NSArray {
                                for item_ in assgts {
                                    if let assgtItem = item_ as? NSDictionary {
                                        let name = assgtItem["name"] as! String
                                        let priority = assgtItem["priority"] as! Int
                                        if let dateStr = assgtItem["due"] as? String {
                                            asgtArr.append(Assignment(name: name, priority: priority, dueDate: dateStr))
                                        } else {
                                            asgtArr.append(Assignment(name: name, priority: priority, dueDate: nil))
                                        }
                                    }
                                }
                            }
                            classArr.append(UserClass(className: className, bgValue: bgColor, assignments: asgtArr))
                        }
                    }
                    completion(classArr)
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
    
    /// Gets list of assignments
    public func getAssignments(with user: User, class className: String, completion: @escaping (([Assignment]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var asgtArr: [Assignment] = []
            
            if let dataMap = data.value as? NSDictionary {
                if let classes = dataMap["classes"] as? NSArray {
                    for item in classes {
                        if let classItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let name = classItem["className"] as! String
                            if className == name {
                                if let assgts = classItem["assignments"] as? NSArray {
                                    for item_ in assgts {
                                        if let assgtItem = item_ as? NSDictionary {
                                            let name = assgtItem["name"] as! String
                                            let priority = assgtItem["priority"] as! Int
                                            if let dateStr = assgtItem["due"] as? String {
                                                asgtArr.append(Assignment(name: name, priority: priority, dueDate: dateStr))
                                            } else {
                                                asgtArr.append(Assignment(name: name, priority: priority, dueDate: nil))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    completion(asgtArr)
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
    
    /// Adds new class
    public func addClass(with user: User, with classToAdd: UserClass, completion: @escaping ((Bool, String?) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion(false, "\(err!)")
                return
            }
            
            if let dataMap = data.value as? NSDictionary {
                let newClass : NSDictionary = [ "className" : classToAdd.className, "bgValue" : classToAdd.bgValue, "assignments": []]
                if let classes = dataMap["classes"] as? NSMutableArray {
                    for item in classes {
                        if let classItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let currClassName = classItem["className"] as! String
                            if currClassName == classToAdd.className {
                                completion(false, "Class already exists!")
                                return
                            }
                        }
                    }
                    classes.add(newClass)
                    self.db.child("\(user.escapedEmail)/classes").setValue(classes)
                    completion(true, nil)
                } else {
                    let arr : NSArray = [newClass]
                    self.db.child("\(user.escapedEmail)/classes").setValue(arr)
                    completion(true, nil)
                }
            } else {
                completion(false, "Some error occurred!")
            }
        }
    }
    
    /// Deletes class
    public func removeClass(with user: User, with classToDelete: UserClass, completion: @escaping (([UserClass]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var classArr: [UserClass] = []
            
            let updatedClasses : NSMutableArray = []
            
            if let dataMap = data.value as? NSDictionary {
                if let classes = dataMap["classes"] as? NSMutableArray {
                    for item in classes {
                        if let classItem = item as? NSDictionary {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let className = classItem["className"] as! String
                            let bgColor = classItem["bgValue"] as! Int
                            var asgtArr: [Assignment] = []
                            if let assgts = classItem["assignments"] as? NSArray {
                                for item_ in assgts {
                                    if let assgtItem = item_ as? NSDictionary {
                                        let name = assgtItem["name"] as! String
                                        let priority = assgtItem["priority"] as! Int
                                        if let dateStr = assgtItem["due"] as? String {
                                            asgtArr.append(Assignment(name: name, priority: priority, dueDate: dateStr))
                                        } else {
                                            asgtArr.append(Assignment(name: name, priority: priority, dueDate: nil))
                                        }
                                    }
                                }
                            }
                            if className != classToDelete.className {
                                classArr.append(UserClass(className: className, bgValue: bgColor, assignments: asgtArr))
                                updatedClasses.add(item)
                            }
                        }
                    }
                    self.db.child("\(user.escapedEmail)/classes").setValue(updatedClasses)
                    completion(classArr)
                }
            } else {
                completion([])
            }
        }
    }
    
    /// Adds new assignment
    public func addAssignment(with user: User, class classToAddTo: String, assgt assgtToAdd: Assignment, completion: @escaping ((Bool, String?) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion(false, "\(err!)")
                return
            }
            
            if let dataMap = data.value as? NSDictionary {
                let updatedClasses : NSMutableArray = []
                if let classes = dataMap["classes"] as? NSMutableArray {
                    for item in classes {
                        if var classItem = item as? Dictionary<String, Any> {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let currClassName = classItem["className"] as! String
                            if currClassName == classToAddTo {
                                if let assignments = classItem["assignments"] as? NSMutableArray {
                                    if assgtToAdd.dueDate != nil {
                                        let newAssgt : NSDictionary = [ "name": assgtToAdd.name, "priority": assgtToAdd.priority, "due": assgtToAdd.dueDate! ]
                                        assignments.add(newAssgt)
                                    } else {
                                        let newAssgt : NSDictionary = [ "name": assgtToAdd.name, "priority": assgtToAdd.priority]
                                        assignments.add(newAssgt)
                                    }
                                    classItem["assignments"] = assignments
                                } else {
                                    let newAssgts : NSMutableArray = []
                                    if assgtToAdd.dueDate != nil {
                                        let newAssgt : NSDictionary = [ "name": assgtToAdd.name, "priority": assgtToAdd.priority, "due": assgtToAdd.dueDate! ]
                                        newAssgts.add(newAssgt)
                                    } else {
                                        let newAssgt : NSDictionary = [ "name": assgtToAdd.name, "priority": assgtToAdd.priority]
                                        newAssgts.add(newAssgt)
                                    }
                                    classItem["assignments"] = newAssgts
                                }
                                updatedClasses.add(classItem)
                            } else {
                                updatedClasses.add(classItem)
                            }
                        }
                    }
                    self.db.child("\(user.escapedEmail)/classes").setValue(updatedClasses)
                    completion(true, nil)
                } else {
                    completion(false, "No classes!")
                }
            } else {
                completion(false, "Some error occurred!")
            }
        }
    }
    
    /// Deletes assignment
    public func deleteAssignment(with user: User, class className: String, asgt asgtToDelete: Assignment, completion: @escaping (([Assignment]) -> Void)) {
        db.child(user.escapedEmail).getData { (err, data) in
            guard err == nil else {
                completion([])
                return
            }
            
            var asgtList : [Assignment] = []
            
            if let dataMap = data.value as? NSDictionary {
                let updatedClasses : NSMutableArray = []
                if let classes = dataMap["classes"] as? NSMutableArray {
                    for item in classes {
                        if var classItem = item as? Dictionary<String, Any> {
                            // can forcibly cast here because we guarantee data will not be malformed
                            let currClassName = classItem["className"] as! String
                            var removed = false
                            if currClassName == className {
                                let newAssgts : NSMutableArray = []
                                if let assignments = classItem["assignments"] as? NSMutableArray {
                                    for item_ in assignments {
                                        if let asgtItem = item_ as? NSDictionary {
                                            let itemName = asgtItem["name"] as! String
                                            let itemPriority = asgtItem["priority"] as! Int
                                            if let deleteDate = asgtToDelete.dueDate, let itemDate = asgtItem["due"] as? String,
                                               itemName == asgtToDelete.name && itemPriority == asgtToDelete.priority && itemDate == deleteDate && !removed {
                                                removed.toggle()
                                            } else {
                                                newAssgts.add(asgtItem)
                                                if let dateStr = asgtItem["due"] as? String {
                                                    asgtList.append(Assignment(name: itemName, priority: itemPriority, dueDate: dateStr))
                                                } else {
                                                    asgtList.append(Assignment(name: itemName, priority: itemPriority, dueDate: nil))
                                                }
                                            }
                                        }
                                    }
                                    classItem["assignments"] = newAssgts
                                }
                            }
                            updatedClasses.add(classItem)
                        }
                    }
                    self.db.child("\(user.escapedEmail)/classes").setValue(updatedClasses)
                    completion(asgtList)
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
}
