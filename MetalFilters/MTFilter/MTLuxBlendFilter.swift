//
//  MTLuxBlendFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class MTLuxBlendFilter: MTFilter {
    
    var luxBlendAmount: Float = 0
    
    override var parameters: [String : Any] {
        return ["luxBlendAmount": luxBlendAmount]
    }
}
