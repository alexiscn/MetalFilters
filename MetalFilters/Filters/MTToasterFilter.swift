//
//  MTToasterFilter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

class MTToasterFilter: MTFilter {

   override class var name: String {
        return "Toaster"
    }

   override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

   override var fragmentName: String {
        return "MTToasterFragment"
    }

   override var samplers: [String : String] {
        return [
            "colorShift": "toasterColorShift.png",
            "curves": "toasterCurves.png",
            "metal": "metalTexture2.pvr",
            "softLight": "toasterSoftLight.png",
            "vignetteMap": "toasterOverlayMapWarm.png",
        ]
    }

}