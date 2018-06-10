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

#if __METAL_MACOS__ || __METAL_IOS__

namespace metalpetal {
    
    typedef struct {
        float4 position [[ position ]];
        float2 textureCoordinate;
        float2 sourceTextureCoordinate;
    }IFVertexOut;
    
}

#endif

#endif /* IFShaderLib_h */
