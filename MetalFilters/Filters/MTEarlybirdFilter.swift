//
//  MTEarlybirdFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTEarlybirdFilter: MTFilter {

   override class var name: String {
        return "Earlybird"
    }

   override var borderName: String {
        return "earlybirdBorder.png"
    }

   override var fragmentName: String {
        return "MTEarlybirdFragment"
    }

   override var samplers: [String : String] {
        return [
            "blowout": "earlybirdBlowout.png",
            "curves": "earlyBirdCurves.png",
            "earlybirdMap": "earlybirdMap.png",
            "overlayMap": "earlybirdOverlayMap.png",
            "vignetteMap": "plusDarker.png",
        ]
    }

}