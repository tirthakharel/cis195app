//
//  ClassCollectionViewCell.swift
//  cis195app
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    static let identifier = "ClassCell"
    
    public let classLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "-"
        label.textColor = .black
        return label
    }()
    
    public let numAssignments : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 34, weight: .light)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 3)
        layer.shadowOpacity = 0.3;
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        self.contentView.addSubview(classLabel)
        self.contentView.addSubview(numAssignments)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        classLabel.frame = CGRect(x: 10, y: 25, width: self.contentView.width - 15, height: 25)
        numAssignments.frame = CGRect(x: 10, y: classLabel.bottom + 10, width: self.contentView.width - 15, height: self.contentView.height - 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
