//
//  IFHudsonFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFHudsonFilter: NSObject, IFFilter {
    
    var borderName: String {
        return ""
    }
    
    var samplers: [String : String] {
        return [:]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    
    var name: String {
        return "Hudson"
    }
    
    var metalEntranceName: String {
        return "hudson"
    }
}
