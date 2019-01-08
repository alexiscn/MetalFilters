//
//  FilterToolItem.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

enum FilterControlType {
    case adjustStrength
    case edit(FilterEditType)
}

enum FilterEditType {
    case adjust
    case brightness
    case contrast
    case structure
    case warmth
    case saturation
    case color
    case fade
    case highlights
    case shadows
    case vignette
    case tiltShift
    case sharpen
    
    var title: String {
        switch self {
        case .adjust:
            return "Adjust"
        case .brightness:
            return "Brightness"
        case .contrast:
            return "Contrast"
        case .structure:
            return "Structure"
        case .warmth:
            return "Warmth"
        case .saturation:
            return "Saturation"
        case .color:
            return "Color"
        case .fade:
            return "Fade"
        case .highlights:
            return "Highlights"
        case .shadows:
            return "Shadows"
        case .vignette:
            return "Vignette"
        case .tiltShift:
            return "Tilt Shift"
        case .sharpen:
            return "Sharpen"
        }
    }
    
    var icon: String {
        switch self {
        case .adjust:
            return "icon-structure"
        case .brightness:
            return "icon-brightness"
        case .contrast:
            return "icon-contrast"
        case .structure:
            return "icon-structure"
        case .warmth:
            return "icon-warmth"
        case .saturation:
            return "icon-saturation"
        case .color:
            return "icon-color"
        case .fade:
            return "icon-fade"
        case .highlights:
            return "icon-highlights"
        case .shadows:
            return "icon-shadows"
        case .vignette:
            return "icon-vignette"
        case .tiltShift:
            return "icon-tilt-shift"
        case .sharpen:
            return "icon-sharpen"
        }
    }
}

enum FilterToolType {
    case adjustStrength
    case adjust
    case brightness
    case contrast
    case structure
    case warmth
    case saturation
    case color
    case fade
    case highlights
    case shadows
    case vignette
    case tiltShift
    case sharpen
    
    
}

struct FilterToolItem {
    
    let type: FilterToolType
    
    let slider: SliderValueRange
    
    var title: String {
        switch type {
        case .adjustStrength:
            return ""
        case .adjust:
            return "Adjust"
        case .brightness:
            return "Brightness"
        case .contrast:
            return "Contrast"
        case .structure:
            return "Structure"
        case .warmth:
            return "Warmth"
        case .saturation:
            return "Saturation"
        case .color:
            return "Color"
        case .fade:
            return "Fade"
        case .highlights:
            return "Highlights"
        case .shadows:
            return "Shadows"
        case .vignette:
            return "Vignette"
        case .tiltShift:
            return "Tilt Shift"
        case .sharpen:
            return "Sharpen"
        }
    }
    
    var icon: String {
        switch type {
        case .adjustStrength:
            return ""
        case .adjust:
            return "icon-structure"
        case .brightness:
            return "icon-brightness"
        case .contrast:
            return "icon-contrast"
        case .structure:
            return "icon-structure"
        case .warmth:
            return "icon-warmth"
        case .saturation:
            return "icon-saturation"
        case .color:
            return "icon-color"
        case .fade:
            return "icon-fade"
        case .highlights:
            return "icon-highlights"
        case .shadows:
            return "icon-shadows"
        case .vignette:
            return "icon-vignette"
        case .tiltShift:
            return "icon-tilt-shift"
        case .sharpen:
            return "icon-sharpen"
        }
    }
}
