//
//  MTNormalFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTNormalFilter: MTFilter {

   override class var name: String {
        return "Normal"
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