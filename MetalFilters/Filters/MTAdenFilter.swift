//
//  MTAdenFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTAdenFilter: MTFilter {

   override class var name: String {
        return "Aden"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTAdenFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "aden_map.png",
        ]
    }

}