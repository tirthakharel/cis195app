//
//  ToDoReusableCollectionViewCell.swift
//  cis195app
//

import UIKit

class ToDoReusableCollectionViewCell: UICollectionViewListCell {
    static let identifier = "ToDoItem"
    
    public let taskLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    public let priorityLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
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
        self.contentView.addSubview(priorityLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskLabel.frame = CGRect(x: 10, y: self.contentView.frame.midY / 2, width: self.contentView.width * (3/5), height: 20)
        priorityLabel.frame = CGRect(x: 10, y: taskLabel.bottom + 5, width: taskLabel.width, height: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
