//
//  MTSierraFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTSierraFilter: MTFilter {

   override class var name: String {
        return "Sierra"
    }

   override var borderName: String {
        return "sierraBorder.png"
    }

   override var fragmentName: String {
        return "MTSierraFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "sierraMap.png",
            "overlay": "overlayMap.png",
            "smoke": "sierraSmoke.png",
            "softLight": "softLight100.png",
            "vignette": "sierraVignette.png",
        ]
    }

}