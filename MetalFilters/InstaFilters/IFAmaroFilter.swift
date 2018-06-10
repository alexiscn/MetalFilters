//
//  IFAmaroFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFAmaroFilter: IFFilter {
    
    override var name: String {
        return "Amaro"
    }
    
    override var fragmentName: String {
        return "amaroFragment"
    }
    
    override var borderName: String {
        return "amaroBorder.png"
    }
    
    override var samplers: [String : String] {
        return [
            "blackboard": "blackboard.png",
            "map": "amaroMap.png",
            "overlay": "overlayMap.png"
        ]
    }
    
}
