//
//  MTXpro2Filter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTXpro2Fragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(1) ]], 
    texture2d<float, access::sample> xproMap [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float2 lookup;
    float3 sampled;
    lookup.y = .5;
    lookup.x = texel.r;
    sampled.r = vignetteMap.sample(s, lookup).r;
    lookup.x = texel.g;
    sampled.g = vignetteMap.sample(s, lookup).g;
    lookup.x = texel.b;
    sampled.b = vignetteMap.sample(s, lookup).b;

    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    float d = dot(tc, tc);
    float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
    texel.rgb = mix(texel.rgb, sampled, value);

    lookup.y = 0.5;
    lookup.x = texel.r;
    texel.r = xproMap.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = xproMap.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = xproMap.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
