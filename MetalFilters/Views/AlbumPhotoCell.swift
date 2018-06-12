//
//  AlbumPhotoCell.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class AlbumPhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView
    
    var assetIdentifier: String = ""
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(white: 1, alpha: 0.7): .clear
        }
    }
    
    override init(frame: CGRect) {
        
        imageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        
        super.init(frame: frame)
        
        backgroundView = imageView
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
