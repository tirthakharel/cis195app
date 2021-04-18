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
}
