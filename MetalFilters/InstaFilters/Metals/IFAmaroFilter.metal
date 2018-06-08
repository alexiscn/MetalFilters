//
//  AmaroFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 amaro(VertexOut vertexIn [[ stage_in ]],
                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                      texture2d<float, access::sample> blackboard [[ texture(2) ]],
                      texture2d<float, access::sample> map [[ texture(3) ]],
                      texture2d<float, access::sample> overlay [[ texture(4) ]],
                      sampler s [[ sampler(0) ]]) {
    
    constexpr sampler edgeSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    
    float4 texel = inputTexture.sample(edgeSampler, vertexIn.textureCoordinate);
    
    float3 bbTexel = blackboard.sample(edgeSampler, vertexIn.textureCoordinate).rgb;
    
    texel.r = overlay.sample(edgeSampler, float2(bbTexel.r, texel.r)).r;
    texel.g = overlay.sample(edgeSampler, float2(bbTexel.g, texel.g)).g;
    texel.b = overlay.sample(edgeSampler, float2(bbTexel.b, texel.b)).b;
    
    float4 mapped;
    mapped.r = map.sample(edgeSampler, float2(texel.r, .16666)).r;
    mapped.g = map.sample(edgeSampler, float2(texel.g, .5)).g;
    mapped.b = map.sample(edgeSampler, float2(texel.b, .83333)).b;
    mapped.a = 1.0;
    
    return mapped;
}
