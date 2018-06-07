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
    
    var metalEntranceName: String { get }
}

extension IFFilter {
    
    var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        let fragmentDescriptor = MTIFunctionDescriptor(name: metalEntranceName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main))
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }
}
