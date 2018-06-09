//
//  IFEarlybirdFilter.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFEarlybirdFilter: NSObject, IFFilter {
    var name: String {
        return "Ear"
    }
    
    var borderName: String {
        return "earlybirdBorder.png"
    }
    
    var fragmentName: String {
        return "earlybirdFragment"
    }
    
    var samplers: [String : String] {
        return ["blowout": "earlybirdBlowout.png",
                "curves": "earlyBirdCurves.png",
                "earlybirdMap": "earlybirdMap.png",
                "overlayMap": "earlybirdOverlayMap.png",
                "vignetteMap": "plusDarker.png"]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    
}
