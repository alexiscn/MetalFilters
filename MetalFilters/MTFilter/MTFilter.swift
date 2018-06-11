//
//  MTFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class MTFilter: NSObject, MTIUnaryFilter {
    
    required override init() { }
    
    // MARK: - Should overrided by subclasses
    class var name: String { return "" }
    
    var borderName: String { return "" }
    
    var fragmentName: String { return "" }

    var samplers: [String: String] { return [:] }
    
    var parameters: [String: Any] { return [:] }

    // MARK: - MTIUnaryFilter
    
    var inputImage: MTIImage?
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var outputImage: MTIImage? {
        guard let input = inputImage else {
            return inputImage
        }
        
        var images: [MTIImage] = [input]
        
        for key in samplers.keys.sorted() {
            let imageName = samplers[key]!
            if imageName.count > 0 {
                let image = samplerImage(named: imageName)!
                images.append(image)
            }
        }
        let outputDescriptors = [
            MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)
        ]
        return kernel.apply(toInputImages: images, parameters: parameters, outputDescriptors: outputDescriptors).first
    }
    
    var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main))
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }
    
    func samplerImage(named name: String) -> MTIImage? {
        if let imageUrl = MTFilterManager.shard.url(forResource: name) {
            let ciImage = CIImage(contentsOf: imageUrl)
            return MTIImage(ciImage: ciImage!, isOpaque: true)
//            return MTIImage(contentsOf: imageUrl, options: [.SRGB: false], alphaType: .alphaIsOne)
        }
        return nil
    }
}
