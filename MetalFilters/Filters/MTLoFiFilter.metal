//
//  MTLoFiFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTLoFiFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> lomoMap [[ texture(1) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float2 red = float2(texel.r, 0.16666);
    float2 green = float2(texel.g, 0.5);
    float2 blue = float2(texel.b, 0.83333);

    texel.rgb = float3(lomoMap.sample(s, red).r,
                     lomoMap.sample(s, green).g,
                     lomoMap.sample(s, blue).b);

    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    float d = dot(tc, tc);
    float2 lookup = float2(d, texel.r);
    texel.r = vignetteMap.sample(s, lookup).r;
    lookup.y = texel.g;
    texel.g = vignetteMap.sample(s, lookup).g;
    lookup.y = texel.b;
    texel.b    = vignetteMap.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
