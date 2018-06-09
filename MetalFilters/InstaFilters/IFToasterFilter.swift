//
//  IFToasterFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFToasterFilter: NSObject, IFFilter {
    
    var name: String {
        return "toaster"
    }
    
    var borderName: String {
        return "filterBorderPlainWhite.png"
    }
    
    var fragmentName: String {
        return "toasterFragment"
    }
    
    var samplers: [String : String] {
        return [
            "colorShift": "toasterColorShift.png",
                "curves": "toasterCurves.png",
                "metal": "metalTexture2.pvr",
                "softLight": "toasterSoftLight.png",
                "vignetteMap": "toasterOverlayMapWarm.png"]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    
}
