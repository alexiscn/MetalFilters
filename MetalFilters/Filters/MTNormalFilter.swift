//
//  MTNormalFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTNormalFilter: MTFilter {

   override var name: String {
        return "MTNormalFilter"
    }

   override var borderName: String {
        return ""
    }

   override var fragmentName: String {
        return "MTNormalFragment"
    }

   override var samplers: [String : String] {
        return [
            :
        ]
    }

}