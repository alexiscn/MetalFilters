//
//  MTClarendonVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTClarendonVideoFilter: MTFilter {

   override class var name: String {
        return "Clarendon"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTClarendonVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "Glacial1.png",
            "map2": "Glacial2.png",
        ]
    }

}