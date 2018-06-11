//
//  MTCremaFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTCremaFilter: MTFilter {

   override class var name: String {
        return "Crema"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTCremaFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "crema_map.png",
        ]
    }

}