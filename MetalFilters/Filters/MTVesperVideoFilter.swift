//
//  MTVesperVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTVesperVideoFilter: MTFilter {

   override var name: String {
        return "MTVesperVideoFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTVesperVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "luster_map.png",
        ]
    }

}