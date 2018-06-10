//
//  MTKelvinFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTKelvinFilter: MTFilter {

   override class var name: String {
        return "Kelvin"
    }

   override var borderName: String {
        return "kelvinBorder.png"
    }

   override var fragmentName: String {
        return "MTKelvinFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "kelvinMap.png",
        ]
    }

}