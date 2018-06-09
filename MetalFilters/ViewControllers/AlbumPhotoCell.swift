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
}
