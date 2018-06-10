//
//  MTCharmesVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTCharmesVideoFilter: MTFilter {

   override class var name: String {
        return "Charmes"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTCharmesVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "vogue_map.png",
        ]
    }

}