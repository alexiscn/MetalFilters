//
//  MT1977Filter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MT1977Filter: MTFilter {

   override var name: String {
        return "MT1977Filter"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MT1977Fragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "1977map.png",
            "screen": "screen30.png",
        ]
    }

}