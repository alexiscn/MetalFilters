//
//  MTSkylineVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTSkylineVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // Exposure adjust B'=B*2^(EV/2.2), EV = 0.5
    texel.rgb = min(texel.rgb * 1.1, float3(1.0));

    // apply curves for map and lift-gamma-gain
    texel.r = map.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map.sample(s, float2(texel.b, 0.5)).b;

    // color effects on shadows and highlights:
    // screen blend shadows under around 0.3 luma
    // linear blend highlights [1.0, 0.105] luma
    float3 highlightColor = float3(1.0, 1.0, 0.043137);
    float3 shadowColor = float3(0.97254, 0.486274, 0.0313725);
    float luma = dot(float3(0.309, 0.609, 0.082), texel.rgb);
    float3 shadowBlend = 1.0 - (1.0 - shadowColor) * (1.0 - texel.rgb);
    float3 highlightBlend = highlightColor + 2.0 * texel.rgb - 1.0;
    float highlightAmount = 0.008 * (luma - 0.15);
    float shadowAmount = 0.07 * max(0.0, (1.0 - 3.0 * luma));
    texel.rgb = mix(mix(texel.rgb, highlightBlend, highlightAmount), shadowBlend, shadowAmount);

    // final saturation pass
    texel.rgb = mix(texel.rgb, float3(luma), -0.225);
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
