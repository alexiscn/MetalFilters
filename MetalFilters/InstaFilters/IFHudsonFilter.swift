//
//  IFHudsonFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFHudsonFilter: NSObject, IFFilter {
    
    var borderName: String {
        return "hudsonBorder.png"
    }
    
    var samplers: [String : String] {
        return [
            "blowout": "hudsonBackground.pvr",
            "map": "hudsonMap.png",
            "overlay": "overlayMap.png"
        ]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    var name: String {
        return "Hudson"
    }
    
    var fragmentName: String {
        return "hudsonFragment"
    }
}
