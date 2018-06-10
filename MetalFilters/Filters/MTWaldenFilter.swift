//
//  MTWaldenFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTWaldenFilter: MTFilter {

   override var name: String {
        return "MTWaldenFilter"
    }

   override var borderName: String {
        return "waldenBorder.png"
    }

   override var fragmentName: String {
        return "MTWaldenFragment"
    }

   override var samplers: [String : String] {
        return [
            "vignetteMap": "vignetteMap.png",
            "waldenMap": "waldenMap.png",
        ]
    }

}