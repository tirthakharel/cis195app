//
//  User.swift
//  cis195app
//
//  Created by Tirtha Kharel on 4/17/21.
//

import Foundation
import UIKit

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

struct ToDo {
    var taskName: String
    var priority: Int
    var dueDate: Date?
    
    var priorityString: String {
        switch priority {
        case 1:
            return "Low Priority"
        case 2:
            return "Medium Priority"
        case 3:
            return "High Priority"
        default:
            return "Low Priority"
        }
    }
    
    var priorityColor: UIColor {
        switch priority {
        case 1:
            return .black
        case 2:
            return .systemBlue
        case 3:
            return .systemRed
        default:
            return .black
        }
    }
}
