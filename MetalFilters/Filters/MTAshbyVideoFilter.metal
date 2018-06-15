//
//  MTAshbyVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTAshbyVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> levels [[ texture(1) ]], 
    texture2d<float, access::sample> tonemap [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // look up luma map and do slight luma adjust
    float luma = dot(float3(0.2126, 0.7152, 0.0722), texel.rgb);
    float adjustCoeff = tonemap.sample(s, float2(luma, 0.5)).r;
    float diff = 1.0 + adjustCoeff - luma;
    texel.rgb = mix(texel.rgb, texel.rgb * diff, 0.5);

    // levels 2
    texel.r = levels.sample(s, float2(texel.r, 0.5)).r;
    texel.g = levels.sample(s, float2(texel.g, 0.5)).g;
    texel.b = levels.sample(s, float2(texel.b, 0.5)).b;

    // slight saturation boost
    float3 lumaFinal = float3(dot(float3(0.2126, 0.7152, 0.0722), texel.rgb));
    texel.rgb = mix(texel.rgb, lumaFinal, -0.1);
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
