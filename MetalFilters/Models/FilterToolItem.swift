//
//  FilterToolItem.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation

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


/// Slider Value Range
///
/// - zeroToHundred: value in [0, 100]
/// - negHundredToHundred: value in [-100, 100], defaluts to 0
/// - tiltShift: tiltShift
/// - adjustStraighten: adjustStraighten, specially handled
enum SliderValueType {
    case zeroToHundred
    case hundredToZero
    case negHundredToHundred
    case tiltShift
    case adjustStraighten
}

struct FilterToolItem {
    
    let type: FilterToolType
    
    let slider: SliderValueType
    
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
