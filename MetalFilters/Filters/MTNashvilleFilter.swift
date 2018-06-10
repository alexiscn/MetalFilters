//
//  MTNashvilleFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTNashvilleFilter: MTFilter {

   override class var name: String {
        return "Nashville"
    }

   override var borderName: String {
        return "nashvilleBorder.png"
    }

   override var fragmentName: String {
        return "MTNashvilleFragment"
    }

   override var samplers: [String : String] {
        return [
            "map": "nashvilleMap.png",
        ]
    }

}