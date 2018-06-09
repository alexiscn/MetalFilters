//
//  FilterPickerCell.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class FilterPickerCell: UICollectionViewCell {
    
    let titleNormalColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    let titleSelectedColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    
    let thumbnailImageView: UIImageView
    
    let titleLabel: UILabel
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? titleSelectedColor: titleNormalColor
        }
    }
    
    override init(frame: CGRect) {
        
        thumbnailImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        let titleOffsetY = frame.height/2 - 50.0 - 30.0
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.frame = CGRect(x: 0, y: titleOffsetY, width: frame.width, height: 30)
        titleLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        thumbnailImageView.center = self.center
        contentView.addSubview(titleLabel)
        contentView.addSubview(thumbnailImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
    }
}
