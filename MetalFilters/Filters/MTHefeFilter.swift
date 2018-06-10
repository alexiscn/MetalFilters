//
//  MTHefeFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTHefeFilter: MTFilter {

   override var name: String {
        return "MTHefeFilter"
    }

   override var borderName: String {
        return "hefeBorder.png"
    }

   override var fragmentName: String {
        return "MTHefeFragment"
    }

   override var samplers: [String : String] {
        return [
            "edgeBurn": "edgeBurn.pvr",
            "gradMap": "hefeGradientMap.png",
            "hefeMetal": "hefeMetal.pvr",
            "map": "hefeMap.png",
            "softLight": "hefeSoftLight.png",
        ]
    }

}