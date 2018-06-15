//
//  MTGinghamVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTGinghamVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
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
    texel.r = map.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map.sample(s, float2(texel.b, 0.5)).b;

    // color effects on shadows:
    float3 shadowColor = float3(0.956862, 0.0, 0.83529);
    float luma = dot(float3(0.309, 0.609, 0.082), texel.rgb);
    float3 shadowBlend = 2.0 * shadowColor * texel.rgb;
    float shadowAmount = 0.6 * max(0.0, (1.0 - 4.0 * luma));
    texel.rgb = mix(texel.rgb, shadowBlend, shadowAmount);

    // apply map for lift-gamma-gain + ranged saturation
    // by applying less lgg (desaturating) to shadows
    float3 lgg;
    lgg.r = mapLgg.sample(s, float2(texel.r, 0.5)).r;
    lgg.g = mapLgg.sample(s, float2(texel.g, 0.5)).g;
    lgg.b = mapLgg.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(texel.rgb, lgg, min(1.0, 0.8 + luma));
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
