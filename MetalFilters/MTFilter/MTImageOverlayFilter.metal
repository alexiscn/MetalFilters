//
//  MTImageOverlayFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/15.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTImageOverlayFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                               texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                               texture2d<float, access::sample> overlay [[ texture(1) ]],
                                               sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 overlayTexel = overlay.sample(s, vertexIn.textureCoordinate);
    texel.rgb = texel.rgb * (1.0 - overlayTexel.a) + overlayTexel.rgb;
    return texel;
}

