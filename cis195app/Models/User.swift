//
//  User.swift
//  cis195app
//
//  Contains User, ToDo, Assignment and Class model
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

struct Assignment {
    var name: String
    var priority: Int
    var dueDate: String?
    
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
    
    var dateString: String {
        if let date = dueDate {
            return date
        }
        return "No due date specified"
    }
}

struct UserClass {
    var className: String
    var bgValue: Int
    var assignments: [Assignment]
    
    var bgColor: UIColor {
        switch bgValue {
        case 1:
            return .blue
        case 2:
            return .red
        case 3:
            return .lightGray
        case 4:
            return .green
        case 5:
            return .yellow
        default:
            return .white
        }
    }
}
