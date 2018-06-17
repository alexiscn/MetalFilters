//
//  MTImageOverlayFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/15.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTImageOverlayFilter: MTFilter {
    
    override var fragmentName: String {
        return "MTImageOverlayFilterFragment"
    }
    
    override func modifySamplersIfNeeded(_ samplers: [MTIImage]) -> [MTIImage] {
        return samplers
    }
}
