//
//  MTVesperVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTVesperVideoFilter: MTFilter {

   override class var name: String {
        return "Vesper"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTVesperVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "luster_map.png",
        ]
    }

}