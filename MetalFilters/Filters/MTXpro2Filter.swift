//
//  MTXpro2Filter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTXpro2Filter: MTFilter {

   override class var name: String {
        return "X-Pro II"
    }

   override var borderName: String {
        return "XPro2Border.png"
    }

   override var fragmentName: String {
        return "MTXpro2Fragment"
    }

   override var samplers: [String : String] {
        return [
            "vignetteMap": "plusDarker.png",
            "xproMap": "xproMap.png",
        ]
    }

}