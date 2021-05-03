//
//  AssignmentTableViewCell.swift
//  cis195app
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    static let identifier = "AssignmentCell"
    
    public let assgtLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "-"
        label.textColor = .black
        return label
    }()
    
    public let priorityLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    public let dateLabel : UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 14)
        return label
    }()
    
    let arrow : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.right")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        self.contentView.addSubview(assgtLabel)
        self.contentView.addSubview(priorityLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(arrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        assgtLabel.frame = CGRect(x: 15, y: 15, width: self.contentView.width - 15, height: 15)
        priorityLabel.frame = CGRect(x: 15, y: assgtLabel.bottom + 5, width: self.contentView.width - 15, height: 15)
        dateLabel.frame = CGRect(x: 15, y: priorityLabel.bottom + 3, width: self.contentView.width - 15, height: 15)
        arrow.frame = CGRect(x: self.contentView.right - 30, y: self.contentView.layer.bounds.midY - 10, width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
