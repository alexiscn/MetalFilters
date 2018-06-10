//
//  MTKelvinFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTKelvinFilter: MTFilter {

   override var name: String {
        return "MTKelvinFilter"
    }

   override var borderName: String {
        return "kelvinBorder.png"
    }

   override var fragmentName: String {
        return "MTKelvinFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "kelvinMap.png",
        ]
    }

}