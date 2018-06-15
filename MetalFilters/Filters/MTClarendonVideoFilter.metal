//
//  MTClarendonVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTClarendonVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
    texture2d<float, access::sample> map2 [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // apply lgg curves
    texel.r = map.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map.sample(s, float2(texel.b, 0.5)).b;

    // darken shadows + saturation
    float luma = dot(float3(0.2126, 0.7152, 0.0722), texel.rgb);
    float shadowCoeff = 0.35 * max(0.0, 1.0 - luma);
    texel.rgb = mix(texel.rgb, max(float3(0.0), 2.0 * texel.rgb - 1.0), shadowCoeff);
    texel.rgb = mix(texel.rgb, float3(luma), -0.3);

    // apply color curves
    texel.r = map2.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map2.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map2.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
