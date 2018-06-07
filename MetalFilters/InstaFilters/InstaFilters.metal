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
                        texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                        sampler s [[ sampler(0) ]])
{
    return float4(1);
}

fragment float4 sutro(VertexOut vertexIn [[ stage_in ]],
                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                      texture2d<float, access::sample> mapTexture [[ texture(2) ]],
                      texture2d<float, access::sample> metalTexture3 [[ texture(3) ]],
                      texture2d<float, access::sample> inputTexture4 [[ texture(4) ]],
                      texture2d<float, access::sample> inputTexture5 [[ texture(5) ]],
                      sampler s [[ sampler(0) ]]) {
    return float4(1);
}

fragment float4 amaro(VertexOut vertexIn [[ stage_in ]],
                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                      texture2d<float, access::sample> blowoutTexture [[ texture(2) ]],
                      texture2d<float, access::sample> overlayTexture [[ texture(3) ]],
                      texture2d<float, access::sample> mapTexture [[ texture(4) ]],
                      sampler s [[ sampler(0) ]]) {
    constexpr sampler edgeSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    
    float4 texel = inputTexture.sample(edgeSampler, vertexIn.textureCoordinate);
    float3 bbTexel = blowoutTexture.sample(edgeSampler, vertexIn.textureCoordinate).rgb;
    
    texel.r = overlayTexture.sample(edgeSampler, float2(bbTexel.r, texel.r)).r;
    texel.g = overlayTexture.sample(edgeSampler, float2(bbTexel.g, texel.g)).g;
    texel.b = overlayTexture.sample(edgeSampler, float2(bbTexel.b, texel.b)).b;
    
    float4 mapped;
    mapped.r = mapTexture.sample(edgeSampler, float2(texel.r, .16666)).r;
    mapped.g = mapTexture.sample(edgeSampler, float2(texel.g, .5)).g;
    mapped.b = mapTexture.sample(edgeSampler, float2(texel.b, .83333)).b;
    mapped.a = 1.0;
    
    return mapped;
}

// 1977
fragment float4 if1977(VertexOut vertexIn [[ stage_in ]],
                       texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                       texture2d<float, access::sample> mapTexture [[ texture(1) ]],
                       sampler s [[ sampler(0) ]])
{
    constexpr sampler edgeSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    
    float3 texel = inputTexture.sample(edgeSampler, vertexIn.textureCoordinate).rgb;
    texel = float3(mapTexture.sample(edgeSampler, float2(texel.r, .16666)).r,
                   mapTexture.sample(edgeSampler, float2(texel.g, .5)).g,
                   mapTexture.sample(edgeSampler, float2(texel.b, .83333)).b);
    return float4(texel, 1.0);
}

// valencia
fragment float4 valencia(VertexOut vertexIn [[stage_in]],
                         texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                         texture2d<float, access::sample> inputTexture2 [[ texture(1) ]],
                         texture2d<float, access::sample> inputTexture3 [[ texture(2) ]],
                         sampler s [[ sampler(0) ]])
{
    float3x3 saturateMatrix = float3x3(1.1402, -0.0598, -0.061,
                                       -0.1174, 1.0826, -0.1186,
                                       -0.0228, -0.0228, 1.1772);
    
    constexpr sampler edgeSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    
    float3 lumaCoeffs = float3(0.3, 0.59, 0.11);
    
    float3 texel = inputTexture.sample(s, vertexIn.textureCoordinate).rgb;
    
    texel = float3(inputTexture2.sample(edgeSampler, float2(texel.r, .1666666)).r,
                   inputTexture2.sample(edgeSampler, float2(texel.g, .5)).g,
                   inputTexture2.sample(edgeSampler, float2(texel.b, .8333333)).b);
    
    texel = saturateMatrix * texel;
    
    float luma = dot(lumaCoeffs, texel);
    texel = float3(inputTexture3.sample(edgeSampler, float2(luma, texel.r)).r,
                   inputTexture3.sample(edgeSampler, float2(luma, texel.g)).g,
                   inputTexture3.sample(edgeSampler, float2(luma, texel.b)).b);
    
    return float4(texel, 1.0);
}
