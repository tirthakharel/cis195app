//
//  SpacerCollectionReusableView.swift
//  cis195app
//

import UIKit

class SpacerCollectionReusableView: UICollectionReusableView {
    static let identifier = "SpacerView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
