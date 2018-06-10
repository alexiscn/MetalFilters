//
//  MTMayfairFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTMayfairFilter: MTFilter {

   override var name: String {
        return "MTMayfairFilter"
    }

   override var borderName: String {
        return "mayfairBorder.png"
    }

   override var fragmentName: String {
        return "MTMayfairFragment"
    }

   override var samplers: [String : String] {
        return [
            "colorOverlay": "mayfairColorOverlay.png",
            "glowField": "mayfairGlowField.png",
            "map": "mayfairColorGradient.png",
            "overlay": "mayfairOverlayMap100.png",
        ]
    }

}