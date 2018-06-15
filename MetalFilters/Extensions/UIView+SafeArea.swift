//
//  UIView+SafeArea.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/15.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

extension UIView {
    
    var keyWindowSafeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}
