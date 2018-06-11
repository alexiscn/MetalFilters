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
    
    METAL_FUNC float4 metalColorLookUp(texture2d<float, access::sample> lutTexture, sampler lutSamper, float3 texCoord, float size) {
        float sliceSize = 1.0 / size;
        float slicePixelSize = sliceSize / size;
        float sliceInnerSize = slicePixelSize * (size - 1.0);
        float xOffset = 0.5 * sliceSize + texCoord.x * (1.0 - sliceSize);
        
        float yOffset = 0.5 * slicePixelSize + texCoord.y * sliceInnerSize;
        float zOffset = texCoord.z * (size - 1.0);
        float zSlice0 = floor(zOffset);
        float zSlice1 = zSlice0 + 1.0;
        float s0 = yOffset + (zSlice0 * sliceSize);
        float s1 = yOffset + (zSlice1 * sliceSize);
        float4 slice0Color = lutTexture.sample(lutSamper, float2(xOffset, s0));
        float4 slice1Color = lutTexture.sample(lutSamper, float2(xOffset, s1));
        return mix(slice0Color, slice1Color, zOffset - zSlice0);
    }
}

#endif

#endif /* IFShaderLib_h */
