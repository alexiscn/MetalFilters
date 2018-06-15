//
//  MTKelvinFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTKelvinFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float2 lookup;
    lookup.y = .5;

    lookup.x = texel.r;
    texel.r = map.sample(s, lookup).r;

    lookup.x = texel.g;
    texel.g = map.sample(s, lookup).g;

    lookup.x = texel.b;
    texel.b = map.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
