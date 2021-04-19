//
//  ClassesCollectionViewCell.swift
//  cis195app
//

import UIKit

class ClassesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ClassesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
