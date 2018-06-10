//
//  IFSutroFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFSutroFilter: IFFilter {
    
    override var name: String {
        return "Sutro"
    }
    
    override var borderName: String {
        return "sutroBorder.png"
    }
    
    override var fragmentName: String {
        return "sutroFragment"
    }
    
    override var samplers: [String : String] {
        return [
            "curves": "sutroCurves.png",
            "edgeBurn": "sutroEdgeBurn.pvr",
            "softLight": "softLight.png",
            "sutroMetal": "sutroMetal.pvr",
            "vignetteMap": "blackOverlayMap.png"
        ]
    }
    
}
