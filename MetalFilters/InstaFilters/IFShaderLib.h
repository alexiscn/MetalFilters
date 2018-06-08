//
//  IFShaderLib.h
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#ifndef IFShaderLib_h
#define IFShaderLib_h

#include <metal_stdlib>

using namespace metal;

namespace metalpetal {
    
    typedef struct {
        float2 textureCoordinate;
        float2 sourceTextureCoordinate;
        float4 position [[ position ]];
    } IFVertexOut;
    
}

#endif /* IFShaderLib_h */
