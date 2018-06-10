//
//  MTNormalFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTNormalFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    
    texel.rgb = mix(inputTexel.rgb, texel.rgb, 1.0);
    return texel;
}
