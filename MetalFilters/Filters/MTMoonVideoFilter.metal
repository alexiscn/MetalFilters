//
//  MTMoonVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTMoonVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map1 [[ texture(1) ]], 
    texture2d<float, access::sample> map2 [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // apply curves
    texel.r = map1.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map1.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map1.sample(s, float2(texel.b, 0.5)).b;

    // saturation
    float3 desat = float3(dot(float3(0.7, 0.2, 0.1), texel.rgb));
    texel.rgb = mix(texel.rgb, desat, 0.79);

    // channel-weighted bw conversion and exposure boost
    texel.rgb = float3(min(1.0, 1.2 * dot(float3(0.2, 0.7, 0.1), texel.rgb)));

    // apply final curves and lgg
    texel.r = map2.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map2.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map2.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
