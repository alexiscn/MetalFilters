//
//  IFHudsonFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFHudsonFilter: IFFilter {
    
    override var borderName: String {
        return "hudsonBorder.png"
    }
    
    override var samplers: [String : String] {
        return [
            "blowout": "hudsonBackground.pvr",
            "map": "hudsonMap.png",
            "overlay": "overlayMap.png"
        ]
    }
    
    override var name: String {
        return "Hudson"
    }
    
    override var fragmentName: String {
        return "hudsonFragment"
    }
}
