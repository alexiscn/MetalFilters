//
//  MTWillowFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTWillowFilter: MTFilter {

   override class var name: String {
        return "Willow"
    }

   override var borderName: String {
        return "willowBorder.png"
    }

   override var fragmentName: String {
        return "MTWillowFragment"
    }

   override var samplers: [String : String] {
        return [
            "borderTexture": "borderTexture.png",
            "glowMap": "glowField.png",
            "map": "willowMap.png",
            "overlayMap": "overlayMap81.png",
            "softLightMap": "willowSoftLight100.png",
            "vignette": "willowVignette.png",
        ]
    }

}