//
//  ToolPickerCell.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class ToolPickerCell: UICollectionViewCell {

    private let borderView: UIView
    
    private let iconView: UIImageView
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        titleLabel.frame.size = CGSize(width: frame.width, height: 12)
        titleLabel.textAlignment = .center
        
        borderView = UIView()
        borderView.frame.size = CGSize(width: 88, height: 88)
        borderView.layer.cornerRadius = 44
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        
        iconView = UIImageView()
        iconView.frame.size = CGSize(width: 64, height: 64)
        
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(borderView)
        contentView.addSubview(iconView)
        
        titleLabel.frame.origin = CGPoint(x: 0, y: frame.height/2 - 44 - 22)
        borderView.center = contentView.center
        iconView.center = contentView.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func update(_ tool: FilterToolItem) {
        iconView.image = UIImage(named: tool.icon)
        titleLabel.text = tool.title
    }
}
