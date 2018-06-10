//
//  MTAshbyVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTAshbyVideoFilter: MTFilter {

   override var name: String {
        return "MTAshbyVideoFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTAshbyVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "levels": "classy_look_levels2.png",
            "tonemap": "classy_look_tonemap1.png",
        ]
    }

}