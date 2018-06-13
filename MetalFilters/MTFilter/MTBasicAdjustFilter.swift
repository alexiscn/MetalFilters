//
//  MTBasicAdjustFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/11.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTBasicAdjustFilter: MTFilter {
    
    var brightness: Float = 0
    var contrast: Float = 0
    var saturation: Float = 0
    var temperature: Float = 0
    var vignette: Float = 0
    var fade: Float = 0
    var highlights: Float = 0
    var shadows: Float = 0
    var sharpen: Float = 0
    var sharpenDisabled: Bool = false
    var tintShadowsIntensity: Float = 0.5
    var tintHighlightsIntensity: Float = 0.5
    var tintShadowsColor: UIColor = .clear
    var tintHighlightsColor: UIColor = .clear
    
    override class var name: String {
        return "Basic Adjust"
    }
    
    override var borderName: String { return "" }
    
    override var fragmentName: String {
        return "MTBasicAdjustFilterFragment"
    }
    
    override var samplers: [String: String] {
        /*
         X: 0.0612549, Y: 0.185368
         X: 0.16381, Y: 0.365771
         X: 0.320955, Y: 0.527539
         X: 0.496851, Y: 0.659237
         X: 0.709977, Y: 0.79987
         X: 1, Y: 1
         X: 0, Y: 0
         X: 0.185368, Y: 0.0612549
         X: 0.365771, Y: 0.16381
         X: 0.527539, Y: 0.320955
         X: 0.659237, Y: 0.496851
         X: 0.79987, Y: 0.709977
         X: 1, Y: 1
 */
        // TODO
        return [
            "blurred": "willowMap.png",
            "sharpenBlur": "willowMap.png",
            "splines": "willowMap.png"
        ]
    }
 
    override var parameters: [String: Any] {
        let color = float3(1)
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
            "sharpenDisabled": (sharpenDisabled || sharpen > 0) ? Float(0.0): Float(1.0),
            "tintShadowsIntensity": tintShadowsIntensity,
            "tintHighlightsIntensity": tintHighlightsIntensity,
            "tintShadowsColor":  MTIVector(float3: color),
            "tintHighlightsColor": MTIVector(float3: color)
        ]
        
    }
}
