//
//  MTBasicFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/11.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

class MTBasicFilter: MTFilter {
    
    var brightness: Float = 0
    var contrast: Float = 0
    var saturation: Float = 0
    var temperature: Float = 0
    var vignette: Float = 0
    var fade: Float = 0
    var highlights: Float = 0
    var shadows: Float = 0
    var sharpen: Float = 0
    var sharpenDisabled: Bool = true
    var tintShadowsIntensity: Float = 0
    var tintHighlightsIntensity: Float = 0
//    constant float3 & tintShadowsColor [[ buffer(12) ]],
//    constant float3 & tintHighlightsColor [[ buffer(13) ]],
    
    override class var name: String { return "" }
    
    override var borderName: String { return "" }
    
    override var fragmentName: String {
        return "MTBasicFilterFragment"
    }
    
    // TODO
    override var samplers: [String: String] { return
        [
            "blurred": "willowMap.png",
            "sharpenBlur": "willowMap.png",
            "splines": "willowMap.png"
        ]
    }
 
    override var parameters: [String: Any] {
        return [
            "brightness" : brightness,
            "contrast": contrast,
            "saturation": saturation,
            "temperature": temperature,
            "vignette": vignette,
            "fade": fade,
            "highlights": highlights,
            "shadows": shadows,
            "sharpen": sharpen,
//            "sharpenDisabled": sharpenDisabled ? 0.0: 1.0,
            "tintShadowsIntensity": tintShadowsIntensity,
            "tintHighlightsIntensity": tintHighlightsIntensity
        ]
        
    }
}
