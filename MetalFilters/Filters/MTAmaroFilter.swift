//
//  MTAmaroFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTAmaroFilter: MTFilter {

   override var name: String {
        return "MTAmaroFilter"
    }

   override var borderName: String {
        return "amaroBorder.png"
    }

   override var fragmentName: String {
        return "MTAmaroFragment"
    }

   override var samplers: [String : String] {
        return [
            "blackboard": "blackboard.png",
            "map": "amaroMap.png",
            "overlay": "overlayMap.png",
        ]
    }

}