//
//  Extensions.swift
//  cis195app
//

import Foundation
import UIKit

extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
}

extension Double {
  static func equal(_ lhs: Double, _ rhs: Double, precise value: Int? = nil) -> Bool {
    guard let value = value else {
      return lhs == rhs
    }
    
    let lhs_precised = lhs.precised(value)
    let rhs_precised = rhs.precised(value)
        
    return lhs_precised == rhs_precised
  }

  func precised(_ value: Int = 1) -> Double {
    let offset = pow(10, Double(value))
    return (self * offset).rounded() / offset
  }
}
