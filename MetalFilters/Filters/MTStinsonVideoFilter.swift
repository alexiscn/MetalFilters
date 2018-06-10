//
//  MTStinsonVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTStinsonVideoFilter: MTFilter {

   override class var name: String {
        return "Stinson"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTStinsonVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "seventies_curves.png",
        ]
    }

}