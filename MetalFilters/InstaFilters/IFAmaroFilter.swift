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
    
    var name: String {
        return "Amaro"
    }
    
    var fragmentName: String {
        return "amaro"
    }
    
    var borderName: String {
        return "amaroBorder.png"
    }
    
    var samplers: [String : String] {
        return [
            "blackboard": "blackboard.png",
            "map": "amaroMap.png",
            "overlay": "overlayMap.png"
        ]
    }
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage? {
        
        guard let input = inputImage else {
            return inputImage
        }
        
        var images: [MTIImage] = [input]
        
        for key in samplers.keys.sorted() {
            let imageName = samplers[key]!
            let image = samplerImage(named: imageName)!
            images.append(image)
        }
        return kernel.apply(toInputImages: images, parameters: [:], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]).first
        
    }
    
    
}
