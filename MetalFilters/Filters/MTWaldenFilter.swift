//
//  MTWaldenFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTWaldenFilter: MTFilter {

   override class var name: String {
        return "Walden"
    }

   override var borderName: String {
        return "waldenBorder.png"
    }

   override var fragmentName: String {
        return "MTWaldenFragment"
    }

   override var samplers: [String : String] {
        return [
            "vignetteMap": "vignetteMap.png",
            "waldenMap": "waldenMap.png",
        ]
    }

}