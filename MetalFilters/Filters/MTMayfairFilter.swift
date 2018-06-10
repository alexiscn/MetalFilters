//
//  MTMayfairFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTMayfairFilter: MTFilter {

   override class var name: String {
        return "Mayfair"
    }

   override var borderName: String {
        return "mayfairBorder.png"
    }

   override var fragmentName: String {
        return "MTMayfairFragment"
    }

   override var samplers: [String : String] {
        return [
            "colorOverlay": "mayfairColorOverlay.png",
            "glowField": "mayfairGlowField.png",
            "map": "mayfairColorGradient.png",
            "overlay": "mayfairOverlayMap100.png",
        ]
    }

}