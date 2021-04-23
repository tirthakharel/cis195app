//
//  ToDoCollectionViewCell.swift
//  cis195app
//

import UIKit

class ToDoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ToDoCollectionViewCell"
    let label : UILabel = {
        let label = UILabel()
        label.text = "To-Dos"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        return label
    }()
    public let numToDos : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .light)
        return label
    }()
    let arrow : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.forward.circle")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 4)
        layer.shadowOpacity = 0.3;
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(arrow)
        self.contentView.addSubview(numToDos)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: 25, width: 0, height: 0)
        label.sizeToFit()
        arrow.frame = CGRect(x: label.right + 8, y: label.frame.midY - 9, width: 20, height: 20)
        numToDos.frame = CGRect(x: 15, y: label.bottom + 10, width: 0, height: 0)
        numToDos.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
