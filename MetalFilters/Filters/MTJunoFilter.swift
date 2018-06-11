//
//  MTJunoFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTJunoFilter: MTFilter {

   override class var name: String {
        return "Juno"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTJunoFragment"
    }

   override var samplers: [String : String] {
        return [
            "lookup": "juno_map.png",
        ]
    }

}