//
//  InstaFilters.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;


fragment float4 toaster(VertexOut vertexIn [[ stage_in ]],
                        texture2d<float, access::sample> inputeTexture [[ texure(0) ]],
                        sampler s [[ sampler(0) ]])
{
    return float4(1);
}

fragment float4 if1977(VertexOut vertexIn [[ stage_in ]],
                       texture2d<float, access::sample> inputeTexture [[ texture(0) ]],
                       texture2d<float, access::sample> mapTexture [[ texture(0) ]],
                       sampler s [[ sampler(0) ]])
{
    float3 texel = inputeTexture.sample(s, vertexIn.textureCoordinate).rgb;
    texel = float3(mapTexture.sample(s, float2(texel.r, .16666)).r,
                   mapTexture.sample(s, float2(texel.g, .5)).g,
                   mapTexture.sample(s, float2(texel.b, .83333)).b);
    return float4(texel, 1.0);
}
