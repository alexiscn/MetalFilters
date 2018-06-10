//
//  MTGinghamVideoFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTGinghamVideoFilter: MTFilter {

   override class var name: String {
        return "Gingham"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTGinghamVideoFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "vintage_signature_curves1.png",
            "mapLgg": "vintage_signature_lgg_curves.png",
        ]
    }

}