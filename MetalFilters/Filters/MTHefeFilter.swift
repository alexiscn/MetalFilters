//
//  MTHefeFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTHefeFilter: MTFilter {

   override class var name: String {
        return "Hefe"
    }

   override var borderName: String {
        return "hefeBorder.png"
    }

   override var fragmentName: String {
        return "MTHefeFragment"
    }

   override var samplers: [String : String] {
        return [
            "edgeBurn": "edgeBurn.pvr",
            "gradMap": "hefeGradientMap.png",
            "hefeMetal": "hefeMetal.pvr",
            "map": "hefeMap.png",
            "softLight": "hefeSoftLight.png",
        ]
    }

}