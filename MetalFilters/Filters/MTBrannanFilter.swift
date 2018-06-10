//
//  MTBrannanFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTBrannanFilter: MTFilter {

   override class var name: String {
        return "Brannan"
    }

   override var borderName: String {
        return "brannanBorder.png"
    }

   override var fragmentName: String {
        return "MTBrannanFragment"
    }

   override var samplers: [String : String] {
        return [
            "blowout": "brannanBlowout.png",
            "brannanMap": "brannanProcess.png",
            "contrast": "brannanContrast.png",
            "lumaMap": "brannanLuma.png",
            "screenMap": "brannanScreen.png",
        ]
    }

}