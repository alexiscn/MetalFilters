//
//  IFToasterFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFToasterFilter: IFFilter {
    
    override var name: String {
        return "toaster"
    }
    
    override var borderName: String {
        return "filterBorderPlainWhite.png"
    }
    
    override var fragmentName: String {
        return "toasterFragment"
    }
    
    override var samplers: [String : String] {
        return [
            "colorShift": "toasterColorShift.png",
                "curves": "toasterCurves.png",
                "metal": "metalTexture2.pvr",
                "softLight": "toasterSoftLight.png",
                "vignetteMap": "toasterOverlayMapWarm.png"]
    }
}
