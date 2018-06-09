//
//  IFValenciaFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFValenciaFilter: NSObject, IFFilter {
    
    var borderName: String {
        return "filterBorderPlainWhite.png"
    }
    
    var samplers: [String : String] {
        return [
            "gradientMap": "valenciaGradientMap.png",
            "map": "valenciaMap.png"
        ]
    }
    
    var name: String {
        return "Valencia"
    }
    
    var fragmentName: String {
        return "valencia"
    }
    
    public var inputImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var outputImage: MTIImage? {
        get {
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
    
    
}
