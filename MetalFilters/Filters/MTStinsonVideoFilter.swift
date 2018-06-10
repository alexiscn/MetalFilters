//
//  MTStinsonVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTStinsonVideoFilter: MTFilter {

   override class var name: String {
        return "Stinson"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTStinsonVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "seventies_curves.png",
        ]
    }

}