//
//  MTLoFiFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTLoFiFilter: MTFilter {

   override class var name: String {
        return "Lo-Fi"
    }

   override var borderName: String {
        return "lomoBorder.png"
    }

   override var fragmentName: String {
        return "MTLoFiFragment"
    }

   override var samplers: [String : String] {
        return [
            "lomoMap": "lomoMap.png",
            "vignetteMap": "blackOverlayMap.png",
        ]
    }

}