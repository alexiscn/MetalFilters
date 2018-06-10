//
//  MTMoonVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTMoonVideoFilter: MTFilter {

   override class var name: String {
        return "Moon"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTMoonVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "bw_vintage_curves1.png",
            "map2": "bw_vintage_curves2.png",
        ]
    }

}