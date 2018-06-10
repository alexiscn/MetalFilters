//
//  MTSierraFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTSierraFilter: MTFilter {

   override var name: String {
        return "MTSierraFilter"
    }

   override var borderName: String {
        return "sierraBorder.png"
    }

   override var fragmentName: String {
        return "MTSierraFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "sierraMap.png",
            "overlay": "overlayMap.png",
            "smoke": "sierraSmoke.png",
            "softLight": "softLight100.png",
            "vignette": "sierraVignette.png",
        ]
    }

}