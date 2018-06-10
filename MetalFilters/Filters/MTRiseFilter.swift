//
//  MTRiseFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTRiseFilter: MTFilter {

   override var name: String {
        return "MTRiseFilter"
    }

   override var borderName: String {
        return "riseBorder.png"
    }

   override var fragmentName: String {
        return "MTRiseFragment"
    }

   override var samplers: [String : String] {
        return [
            "blowout": "blackboard.png",
            "map": "riseMap.png",
            "overlay": "overlayMap.png",
        ]
    }

}