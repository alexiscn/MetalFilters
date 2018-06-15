//
//  MTVesperVideoFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTVesperVideoFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    texel.r = map.sample(s, float2(texel.r, 0.5)).r;
    texel.g = map.sample(s, float2(texel.g, 0.5)).g;
    texel.b = map.sample(s, float2(texel.b, 0.5)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
