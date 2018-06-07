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
    var name: String {
        return "Valencia"
    }
    
    var metalEntranceName: String {
        return "valencia"
    }
    
    public var inputImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    var gradientMapImage: MTIImage?
    
    var mapImage: MTIImage?
    
    public var outputImage: MTIImage? {
        get {
            guard let input = inputImage, let gradientMapImage = gradientMapImage, let mapImage = mapImage else {
                return inputImage
            }
            
            let output = kernel.apply(toInputImages: [input, mapImage, gradientMapImage], parameters: [:], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]).first
            return output
        }
    }
}
