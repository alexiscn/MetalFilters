//
//  MTValenciaFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTValenciaFilter: MTFilter {

   override class var name: String {
        return "Valencia"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTValenciaFragment"
    }

   override var samplers: [String : String] {
        return [
            "gradientMap": "valenciaGradientMap.png",
            "map": "valenciaMap.png",
        ]
    }

}