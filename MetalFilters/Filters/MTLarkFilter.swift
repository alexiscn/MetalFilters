//
//  MTLarkFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTLarkFilter: MTFilter {

   override class var name: String {
        return "Lark"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTLarkFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "lark_map.png",
        ]
    }

}