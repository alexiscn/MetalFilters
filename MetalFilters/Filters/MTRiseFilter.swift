//
//  MTRiseFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTRiseFilter: MTFilter {

   override class var name: String {
        return "Rise"
    }

   override var borderName: String {
        return "riseBorder.png"
    }

   override var fragmentName: String {
        return "MTRiseFragment"
    }

   override var samplers: [String : String] {
        return [
            "blowout": "blackboard.png",
            "map": "riseMap.png",
            "overlay": "overlayMap.png",
        ]
    }

}