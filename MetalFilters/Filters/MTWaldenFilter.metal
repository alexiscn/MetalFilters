//
//  MTWaldenFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTWaldenFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(1) ]], 
    texture2d<float, access::sample> waldenMap [[ texture(2) ]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    texel.rgb = float3(waldenMap.sample(s, float2(texel.r, .16666)).r,
                     waldenMap.sample(s, float2(texel.g, .5)).g,
                     waldenMap.sample(s, float2(texel.b, .83333)).b);

    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;

    float d = dot(tc, tc);
    float2 lookup = float2(d, texel.r);

    texel.r = vignetteMap.sample(s, lookup).r;
    lookup.y = texel.g;
    texel.g = vignetteMap.sample(s, lookup).g;
    lookup.y = texel.b;
    texel.b    = vignetteMap.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, 1.0);
    return texel;
}
