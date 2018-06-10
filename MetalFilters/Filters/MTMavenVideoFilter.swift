//
//  MTMavenVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTMavenVideoFilter: MTFilter {

   override class var name: String {
        return "Maven"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTMavenVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map1": "Lansdowne1.png",
            "map2": "Lansdowne2.png",
        ]
    }

}