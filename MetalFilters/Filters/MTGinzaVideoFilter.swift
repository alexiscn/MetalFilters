//
//  MTGinzaVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTGinzaVideoFilter: MTFilter {

   override var name: String {
        return "MTGinzaVideoFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTGinzaVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "chic_curves1.png",
            "map2": "chic_curves2.png",
        ]
    }

}