//
//  MTBrannanFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTBrannanFilter: MTFilter {

   override var name: String {
        return "MTBrannanFilter"
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