//
//  MTReyesFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTReyesFilter: MTFilter {

   override class var name: String {
        return "Reyes"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTReyesFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "reyes_map.png",
        ]
    }

}