//
//  User.swift
//  cis195app
//
//  Created by Tirtha Kharel on 4/17/21.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let emailAddr: String
    
    var escapedEmail: String {
        var escapedEmail = emailAddr.replacingOccurrences(of: ".", with: "-")
        escapedEmail = escapedEmail.replacingOccurrences(of: "@", with: "-")
        return escapedEmail
    }
}
