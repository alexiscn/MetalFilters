//
//  MTDogpatchVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTDogpatchVideoFilter: MTFilter {

   override class var name: String {
        return "Dogpatch"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTDogpatchVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "bleach_reduction_curves1.png",
            "mapLgg": "bleach_reduction_lgg.png",
        ]
    }

}