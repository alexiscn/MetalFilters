//
//  MTPerpetuaFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTPerpetuaFilter: MTFilter {

   override class var name: String {
        return "Perpetua"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTPerpetuaFragment"
    }

   override var samplers: [String : String] {
        return [
            "gradient": "perpetua_overlay.png",
            "lookup": "perpetua_map.png",
        ]
    }

}