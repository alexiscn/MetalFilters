//
//  MTCharmesVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTCharmesVideoFilter: MTFilter {

   override var name: String {
        return "MTCharmesVideoFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTCharmesVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "vogue_map.png",
        ]
    }

}