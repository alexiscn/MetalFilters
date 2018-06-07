//
//  IFAmaroFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFAmaroFilter: NSObject, IFFilter {
    
    var inputImage: MTIImage?
    
    var mapImage: MTIImage?
    
    var overlayImage: MTIImage?
    
    var blowoutImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage? {
        guard let input = inputImage, let overlayImage = overlayImage, let blowoutImage = blowoutImage, let mapImage = mapImage else {
            return inputImage
        }
        let output = kernel.apply(toInputImages: [input, blowoutImage, overlayImage, mapImage], parameters: [:], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]).first
        return output
    }
    
    var name: String {
        return "Amaro"
    }
    
    var metalEntranceName: String {
        return "amaro"
    }
}
