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
    
    var name: String {
        return ""
    }
    
    var borderName: String { return "" }

    var fragmentName: String { return "" }

    var samplers: [String: String] { return [:] }

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

extension MTFilter {
    
    
    var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main))
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }
    
    func samplerImage(named name: String) -> MTIImage? {
        
        guard let url = Bundle.main.url(forResource: "FilterAssets", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
                return nil
        }
        let imageUrl = bundle.url(forResource: name, withExtension: nil)!
        return MTIImage(contentsOf: imageUrl, options: [.SRGB: false], alphaType: .alphaIsOne)
    }
}
