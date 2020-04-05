//
//  MTEarlybirdFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTEarlybirdFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> blowout [[ texture(1) ]], 
    texture2d<float, access::sample> curves [[ texture(2) ]], 
    texture2d<float, access::sample> earlybirdMap [[ texture(3) ]], 
    texture2d<float, access::sample> overlayMap [[ texture(4) ]], 
    texture2d<float, access::sample> vignetteMap [[ texture(5) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    const float3x3 saturate = float3x3(1.210300,
              -0.089700,
              -0.091000,
              -0.176100,
              1.123900,
              -0.177400,
              -0.034200,
              -0.034200,
              1.265800);

    //const float3 rgbPrime = float3(0.25098, 0.14640522, 0.0);
    const float3 desaturate = float3(.3, .59, .11);

    float2 lookup;
    lookup.y = 0.5;

    lookup.x = texel.r;
    texel.r = curves.sample(s, lookup).r;

    lookup.x = texel.g;
    texel.g = curves.sample(s, lookup).g;

    lookup.x = texel.b;
    texel.b = curves.sample(s, lookup).b;

    float desaturatedColor;
    float3 result;
    desaturatedColor = dot(desaturate, texel.rgb);


    lookup.x = desaturatedColor;
    result.r = overlayMap.sample(s, lookup).r;
    lookup.x = desaturatedColor;
    result.g = overlayMap.sample(s, lookup).g;
    lookup.x = desaturatedColor;
    result.b = overlayMap.sample(s, lookup).b;

    texel.rgb = saturate * mix(texel.rgb, result, .5);

    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    float d = dot(tc, tc);

    float3 sampled;
    lookup.y = .5;

    lookup.x = texel.r;
    sampled.r = vignetteMap.sample(s, lookup).r;

    lookup.x = texel.g;
    sampled.g = vignetteMap.sample(s, lookup).g;

    lookup.x = texel.b;
    sampled.b = vignetteMap.sample(s, lookup).b;

    float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
    texel.rgb = mix(texel.rgb, sampled, value);

    lookup.x = texel.r;
    sampled.r = blowout.sample(s, lookup).r;
    lookup.x = texel.g;
    sampled.g = blowout.sample(s, lookup).g;
    lookup.x = texel.b;
    sampled.b = blowout.sample(s, lookup).b;
    texel.rgb = mix(sampled, texel.rgb, value);


    lookup.x = texel.r;
    texel.r = earlybirdMap.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = earlybirdMap.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = earlybirdMap.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
