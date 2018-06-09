//
//  IFFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

protocol IFFilter: MTIUnaryFilter {
    
    var name: String { get }
    
    var borderName: String { get }
    
    var fragmentName: String { get }
    
    var samplers: [String: String] { get }
}

extension IFFilter {
    
    
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
