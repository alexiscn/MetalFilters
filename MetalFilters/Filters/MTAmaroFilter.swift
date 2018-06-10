//
//  MTAmaroFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTAmaroFilter: MTFilter {

   override class var name: String {
        return "Amaro"
    }

   override var borderName: String {
        return "amaroBorder.png"
    }

   override var fragmentName: String {
        return "MTAmaroFragment"
    }

   override var samplers: [String : String] {
        return [
            "blackboard": "blackboard.png",
            "map": "amaroMap.png",
            "overlay": "overlayMap.png",
        ]
    }

}