//
//  MTTintColor.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MetalPetal

enum MTTintColor {
    case none
    case yellow
    case orange
    case red
    case pink
    case purple
    case blue
    case lightBlue
    case green
    
    var displayColor: UIColor {
        switch self {
        case .none:
            return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .yellow:
            return UIColor(red: 0.780392, green: 0.760784, blue: 0.180392, alpha: 1)
        case .orange:
            return UIColor(red: 0.780392, green: 0.545098, blue: 0.180392, alpha: 1)
        case .red:
            return UIColor(red: 0.780392, green: 0.180392, blue: 0.180392, alpha: 1)
        case .pink:
            return UIColor(red: 0.768627, green: 0.254902, blue: 0.494118, alpha: 1)
        case .purple:
            return UIColor(red: 0.521569, green: 0.180392, blue: 0.780392, alpha: 1)
        case .blue:
            return UIColor(red: 0.180392, green: 0.235294, blue: 0.780392, alpha: 1)
        case .lightBlue:
            return UIColor(red: 0.180392, green: 0.670588, blue: 0.780392, alpha: 1)
        case .green:
            return UIColor(red: 0.180392, green: 0.780392, blue: 0.235294, alpha: 1)
        }
    }
    
    var colorVector: MTIVector {
        switch self {
        case .none:
            return MTIVector(float3: float3(0.0, 0.0, 0.0))
        case .yellow:
            return MTIVector(float3: float3(1.0, 1.0, 0.0))
        case .orange:
            return MTIVector(float3: float3(1.0, 0.5, 0.0))
        case .red:
            return MTIVector(float3: float3(1.0, 0.0, 0.0))
        case .pink:
            return MTIVector(float3: float3(1.0, 0.0, 1.0))
        case .purple:
            return MTIVector(float3: float3(0.5, 0.0, 1.0))
        case .blue:
            return MTIVector(float3: float3(0.0, 0.0, 1.0))
        case .lightBlue:
            return MTIVector(float3: float3(0.0, 1.0, 1.0))
        case .green:
            return MTIVector(float3: float3(0.0, 1.0, 0.0))
        }
    }
}
