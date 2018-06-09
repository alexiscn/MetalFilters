//
//  IFSutroFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFSutroFilter: NSObject, IFFilter {
    
    var name: String {
        return "Sutro"
    }
    
    var borderName: String {
        return "sutroBorder.png"
    }
    
    var fragmentName: String {
        return "sutroFragment"
    }
    
    var samplers: [String : String] {
        return [
            "curves": "sutroCurves.png",
            "edgeBurn": "sutroEdgeBurn.pvr",
            "softLight": "softLight.png",
            "sutroMetal": "sutroMetal.pvr",
            "vignetteMap": "blackOverlayMap.png"
        ]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    
}
