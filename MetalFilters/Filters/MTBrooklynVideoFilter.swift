//
//  MTBrooklynVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTBrooklynVideoFilter: MTFilter {

   override class var name: String {
        return "Brooklyn"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTBrooklynVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "crossprotwo_curves.png",
        ]
    }

}