//
//  MTHudsonFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTHudsonFilter: MTFilter {

   override class var name: String {
        return "Hudson"
    }

   override var borderName: String {
        return "hudsonBorder.png"
    }

   override var fragmentName: String {
        return "MTHudsonFragment"
    }

   override var samplers: [String : String] {
        return [
            "blowout": "hudsonBackground.pvr",
            "map": "hudsonMap.png",
            "overlay": "overlayMap.png",
        ]
    }

}
