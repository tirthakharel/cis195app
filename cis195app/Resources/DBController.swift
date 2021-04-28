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
            
            if let dataMap = data.value as! NSDictionary? {
                let dict: NSDictionary = dataMap
                if let firstName = dict["first_name"] as! String?, let lastName = dict["last_name"] as! String? {
                    completion(User(firstName: firstName, lastName: lastName, emailAddr: rawEmail))
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
                if let classes = dict["todos"] as! NSArray? {
                    completion(classes.count)
                } else {
                    completion(0)
                }
            } else {
                completion(-1)
            }
        }
    }
}
