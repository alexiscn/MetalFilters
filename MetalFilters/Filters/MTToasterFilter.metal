//
//  MTToasterFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTToasterFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> colorShift [[ texture(1) ]], 
    texture2d<float, access::sample> curves [[ texture(2) ]], 
    texture2d<float, access::sample> metal [[ texture(3) ]], 
    texture2d<float, access::sample> softLight [[ texture(4) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(5) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    //float2 red;
    //float2 green;
    //float2 blue;
    float2 tc;
    float2 lookup;
    float3 metalSample;
    float d;

    metalSample = metal.sample(s, vertexIn.textureCoordinate).rgb;

    lookup.x = metalSample.r;
    lookup.y = texel.r;
    texel.r = softLight.sample(s, lookup).r;
    lookup.x = metalSample.g;
    lookup.y = texel.g;
    texel.g = softLight.sample(s, lookup).g;
    lookup.x = metalSample.b;
    lookup.y = texel.b;
    texel.b = softLight.sample(s, lookup).b;

    lookup.y = .5;
    lookup.x = texel.r;
    texel.r = curves.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = curves.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = curves.sample(s, lookup).b;

    tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    d = dot(tc, tc);
    lookup = float2(d, texel.r);
    texel.r = vignetteMap.sample(s, lookup).r;
    lookup.y = texel.g;
    texel.g = vignetteMap.sample(s, lookup).g;
    lookup.y = texel.b;
    texel.b    = vignetteMap.sample(s, lookup).b;

    // Exclusion / Soft light
    lookup.y = .5;
    lookup.x = texel.r;
    texel.r = colorShift.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = colorShift.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = colorShift.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
