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

   override class var name: String {
        return "Kelvin"
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