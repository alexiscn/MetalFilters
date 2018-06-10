//
//  MTAshbyVideoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTAshbyVideoFilter: MTFilter {

   override class var name: String {
        return "Ashby"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTAshbyVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "levels": "classy_look_levels2.png",
            "tonemap": "classy_look_tonemap1.png",
        ]
    }

}