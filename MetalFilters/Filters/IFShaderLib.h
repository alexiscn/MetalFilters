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
    
    METAL_FUNC float3 rgb_to_hsv(float3 c) {
        float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
        float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
        
        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }
    
    METAL_FUNC float3 hsv_to_rgb(float3 c) {
        float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    
    METAL_FUNC float3 yuvToRgb(float3 inP) {
        float y = inP.r;
        float u = inP.g;
        float v = inP.b;
        float3 outP;
        outP.r = 1.402 * v + y;
        outP.g = (y - (0.299 * 1.402 / 0.587) * v -
                  (0.114 * 1.772 / 0.587) * u);
        outP.b = 1.772 * u + y;
        return outP;
    }
    
    METAL_FUNC float getLuma(float3 rgbP) {
        return  (0.299 * rgbP.r) +
        (0.587 * rgbP.g) +
        (0.114 * rgbP.b);
    }
    
    METAL_FUNC float3 rgbToYuv(float3 inP) {
        float3 outP;
        outP.r = getLuma(inP);
        outP.g = (1.0/1.772)*(inP.b - outP.r);
        outP.b = (1.0/1.402)*(inP.r - outP.r);
        return outP;
    }
}

#endif

#endif /* IFShaderLib_h */
