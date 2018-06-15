//
//  MTGinzaVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTGinzaVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map1 [[ texture(1) ]], 
    texture2d<float, access::sample> map2 [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // curves and blue fill light
    texel.r = map1.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map1.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map1.sample(s, float2(texel.b, 0.5)).b;

    // increase saturation - channel weighted
    texel.rgb = mix(texel.rgb, float3(dot(float3(0.3, 0.6, 0.07), texel.rgb)), -0.1);
    // slight boost to orange
    texel.r = min(1.0, texel.r * 1.04);
    texel.g = min(1.0, texel.g * 1.03);

    // lift gamma gain and warm tint map
    texel.r = map2.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map2.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map2.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
