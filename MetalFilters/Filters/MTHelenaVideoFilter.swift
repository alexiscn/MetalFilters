//
//  MTHelenaVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTHelenaVideoFilter: MTFilter {

   override var name: String {
        return "MTHelenaVideoFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTHelenaVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "epic_1.png",
            "map2": "epic_2.png",
        ]
    }

}