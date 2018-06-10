//
//  MTHefeFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTHefeFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> edgeBurn [[ texture(1) ]], 
    texture2d<float, access::sample> gradMap [[ texture(2) ]], 
    texture2d<float, access::sample> hefeMetal [[ texture(3) ]], 
    texture2d<float, access::sample> map [[ texture(4) ]], 
    texture2d<float, access::sample> softLight [[ texture(5) ]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float3 edge = edgeBurn.sample(s, vertexIn.textureCoordinate).rgb;
    texel.rgb = texel.rgb * edge;

    texel.rgb = float3(map.sample(s, float2(texel.r, .16666)).r,
                     map.sample(s, float2(texel.g, .5)).g,
                     map.sample(s, float2(texel.b, .83333)).b);

    float3 luma = float3(.30, .59, .11);
    float3 gradSample = gradMap.sample(s, float2(dot(luma, texel.rgb), .5)).rgb;
    float3 final = float3(softLight.sample(s, float2(gradSample.r, texel.r)).r,
                      softLight.sample(s, float2(gradSample.g, texel.g)).g,
                      softLight.sample(s, float2(gradSample.b, texel.b)).b);

    float3 metal = hefeMetal.sample(s, vertexIn.textureCoordinate).rgb;
    float3 metaled = float3(softLight.sample(s, float2(metal.r, final.r)).r,
                        softLight.sample(s, float2(metal.g, final.g)).g,
                        softLight.sample(s, float2(metal.b, final.b)).b);

    texel.rgb = metaled;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, 1.0);
    return texel;
}
