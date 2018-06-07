//
//  IFSutroFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFSutroFilter: NSObject, MTIUnaryFilter {
    
    var inputImage: MTIImage?
    
    var borderImage: MTIImage?
    
    var curvesImage: MTIImage?
    
    var mapImage: MTIImage?
    
    var metalImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage?
    
    
}
