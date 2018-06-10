//
//  MTHelenaVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTHelenaVideoFilter: MTFilter {

   override class var name: String {
        return "Helena"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTHelenaVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "epic_1.png",
            "map2": "epic_2.png",
        ]
    }

}