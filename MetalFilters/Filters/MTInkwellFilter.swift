//
//  MTInkwellFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTInkwellFilter: MTFilter {

   override class var name: String {
        return "Inkwell"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTInkwellFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "inkwellMap.png",
        ]
    }

}