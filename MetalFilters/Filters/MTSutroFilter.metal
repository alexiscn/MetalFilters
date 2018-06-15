//
//  MTSutroFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTSutroFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> curves [[ texture(1) ]], 
    texture2d<float, access::sample> edgeBurn [[ texture(2) ]], 
    texture2d<float, access::sample> softLight [[ texture(3) ]], 
    texture2d<float, access::sample> sutroMetal [[ texture(4) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(5) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    float d = dot(tc, tc);
    float2 lookup = float2(d, texel.r);
    texel.r = vignetteMap.sample(s, lookup).r;
    lookup.y = texel.g;
    texel.g = vignetteMap.sample(s, lookup).g;
    lookup.y = texel.b;
    texel.b    = vignetteMap.sample(s, lookup).b;

    float3 rgbPrime = float3(0.1019, 0.0, 0.0);
    float m = dot(float3(.3, .59, .11), texel.rgb) - 0.03058;
    texel.rgb = mix(texel.rgb, rgbPrime + m, 0.32);

    float3 metal = sutroMetal.sample(s, vertexIn.textureCoordinate).rgb;
    texel.r = softLight.sample(s, float2(metal.r, texel.r)).r;
    texel.g = softLight.sample(s, float2(metal.g, texel.g)).g;
    texel.b = softLight.sample(s, float2(metal.b, texel.b)).b;

    texel.rgb = texel.rgb * edgeBurn.sample(s, vertexIn.textureCoordinate).rgb;

    texel.r = curves.sample(s, float2(texel.r, .16666)).r;
    texel.g = curves.sample(s, float2(texel.g, .5)).g;
    texel.b = curves.sample(s, float2(texel.b, .83333)).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
