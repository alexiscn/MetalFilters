//
//  IFMoonFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFMoonFilter: NSObject, IFFilter {
    
    var name: String {
        return "Moon"
    }
    
    var borderName: String {
        return ""
    }
    
    var fragmentName: String {
        return "moon"
    }
    
    var samplers: [String : String] {
        return [
            "map1": "bw_vintage_curves1.png",
            "map2": "bw_vintage_curves2.png"
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
