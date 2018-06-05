//
//  IF1977Filter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IF1977Filter: NSObject, MTIUnaryFilter {
    
    static private let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName), fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "if1977", libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main)))
    
    var inputImage: MTIImage?
    
    var mapImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage? {
        guard let input = inputImage, let map = mapImage else {
            return inputImage
        }
        return IF1977Filter.kernel.apply(toInputImages: [input, map], parameters: [:], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]).first
    }
    
}
