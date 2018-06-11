//
//  MTLudwigFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTLudwigFilter: MTFilter {

   override class var name: String {
        return "Ludwig"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTLudwigFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "ludwig_map.png",
        ]
    }

}