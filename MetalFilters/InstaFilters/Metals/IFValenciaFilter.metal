//
//  IFValenciaFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

// valencia
fragment float4 valencia(VertexOut vertexIn [[stage_in]],
                         texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                         texture2d<float, access::sample> gradientMap [[ texture(1) ]],
                         texture2d<float, access::sample> map [[ texture(2) ]],
                         sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler edgeSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    const float3x3 saturateMatrix = float3x3(1.1402, -0.0598, -0.061, -0.1174, 1.0826, -0.1186, -0.0228, -0.0228, 1.1772);
    const float3 lumaCoeffs = float3(0.3, 0.59, 0.11);
    
    float4 texel = inputTexture.sample(edgeSampler, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    
    texel.rgb = float3(map.sample(edgeSampler, float2(texel.r, .1666666)).r,
                       map.sample(edgeSampler, float2(texel.g, .5)).g,
                       map.sample(edgeSampler, float2(texel.b, .8333333)).b);
    
    texel.rgb = saturateMatrix * texel.rgb;
    
    float luma = dot(lumaCoeffs, texel.rgb);
    texel.rgb = float3(gradientMap.sample(edgeSampler, float2(luma, texel.r)).r,
                       gradientMap.sample(edgeSampler, float2(luma, texel.g)).g,
                       gradientMap.sample(edgeSampler, float2(luma, texel.b)).b);
    texel.rgb = mix(inputTexel.rgb, texel.rgb, 1.0);
    return texel;
}
