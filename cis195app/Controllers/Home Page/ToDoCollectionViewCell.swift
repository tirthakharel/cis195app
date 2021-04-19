//
//  ToDoCollectionViewCell.swift
//  cis195app
//

import UIKit

class ToDoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ToDoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
