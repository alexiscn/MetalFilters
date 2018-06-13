//
//  MTLocalLaplacianFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class MTLocalLaplacianFilter: MTFilter {
    
    var filterStrength: Float = 0
    
    override var fragmentName: String {
        return "MTLocalLaplacianFilterFragment"
    }
    
    override var samplers: [String : String] {
        return [:]
    }
    
    override var parameters: [String: Any] {
        return [ "filterStrength" : filterStrength]
    }
}
