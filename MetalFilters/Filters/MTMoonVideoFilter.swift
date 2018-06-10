//
//  MTMoonVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTMoonVideoFilter: MTFilter {

   override class var name: String {
        return "Moon"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTMoonVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "bw_vintage_curves1.png",
            "map2": "bw_vintage_curves2.png",
        ]
    }

}