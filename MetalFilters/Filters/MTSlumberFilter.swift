//
//  MTSlumberFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTSlumberFilter: MTFilter {

   override class var name: String {
        return "Slumber"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTSlumberFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "slumber_map.png",
        ]
    }

}