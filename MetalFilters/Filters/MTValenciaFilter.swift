//
//  MTValenciaFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTValenciaFilter: MTFilter {

   override var name: String {
        return "MTValenciaFilter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTValenciaFragment"
    }

   override var samplers: [String : String] {
        return [
            "gradientMap": "valenciaGradientMap.png",
            "map": "valenciaMap.png",
        ]
    }

}