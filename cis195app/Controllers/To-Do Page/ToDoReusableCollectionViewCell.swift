//
//  ToDoReusableCollectionViewCell.swift
//  cis195app
//

import UIKit

class ToDoReusableCollectionViewCell: UICollectionViewCell {
    static let identifier = "ToDoItem"
    
    let taskLabel : UILabel = {
        let label = UILabel()
        label.text = "Some task to do"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 2)
        layer.shadowOpacity = 0.5;
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        self.contentView.addSubview(taskLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskLabel.frame = CGRect(x: 5, y: 5, width: self.contentView.width * (3/5), height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
