//
//  MTSutroFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTSutroFilter: MTFilter {

   override class var name: String {
        return "Sutro"
    }

   override var borderName: String {
        return "sutroBorder.png"
    }

   override var fragmentName: String {
        return "MTSutroFragment"
    }

   override var samplers: [String : String] {
        return [
            "curves": "sutroCurves.png",
            "edgeBurn": "sutroEdgeBurn.pvr",
            "softLight": "softLight.png",
            "sutroMetal": "sutroMetal.pvr",
            "vignetteMap": "blackOverlayMap.png",
        ]
    }

}