//
//  MTDogpatchVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTDogpatchVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map1 [[ texture(1) ]], 
    texture2d<float, access::sample> mapLgg [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // exposure adjust B'=B*2^(EV/2.2), EV = 0.4
    texel.rgb = min(texel.rgb * 1.1343, float3(1.0));

    // apply curves
    texel.r = map1.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map1.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map1.sample(s, float2(texel.b, 0.5)).b;

    // desaturation
    float3 luma = float3(dot(float3(0.309, 0.609, 0.082), texel.rgb));
    texel.rgb = mix(texel.rgb, luma, 0.15);

    // apply map for lift-gamma-gain
    texel.r = mapLgg.sample(s, float2(texel.r, 0.5)).r;
    texel.g = mapLgg.sample(s, float2(texel.g, 0.5)).g;
    texel.b = mapLgg.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
