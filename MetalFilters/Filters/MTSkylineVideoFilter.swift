//
//  MTSkylineVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTSkylineVideoFilter: MTFilter {

   override class var name: String {
        return "Skyline"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTSkylineVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "super_film_stock_curves.png",
        ]
    }

}