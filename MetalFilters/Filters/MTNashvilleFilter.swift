//
//  MTNashvilleFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
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