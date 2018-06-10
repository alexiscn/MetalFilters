//
//  MTGinzaVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTGinzaVideoFilter: MTFilter {

   override class var name: String {
        return "Ginza"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTGinzaVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "chic_curves1.png",
            "map2": "chic_curves2.png",
        ]
    }

}