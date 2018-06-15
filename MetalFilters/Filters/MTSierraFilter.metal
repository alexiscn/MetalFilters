//
//  MTSierraFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTSierraFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> map [[ texture(1) ]], 
    texture2d<float, access::sample> overlay [[ texture(2) ]], 
    texture2d<float, access::sample> smoke [[ texture(3) ]], 
    texture2d<float, access::sample> softLight [[ texture(4) ]], 
    texture2d<float, access::sample> vignette [[ texture(5) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float3 color = texel.rgb;
    float3 vignetteSample = vignette.sample(s, vertexIn.textureCoordinate).rgb;

    color.r = overlay.sample(s, float2(vignetteSample.r, color.r)).r;
    color.g = overlay.sample(s, float2(vignetteSample.g, color.g)).g;
    color.b = overlay.sample(s, float2(vignetteSample.b, color.b)).b;

    float3 smokeSample = smoke.sample(s, vertexIn.textureCoordinate).rgb;
    color.r = softLight.sample(s, float2(smokeSample.r, color.r)).r;
    color.g = softLight.sample(s, float2(smokeSample.g, color.g)).g;
    color.b = softLight.sample(s, float2(smokeSample.b, color.b)).b;


    float2 mapSample;
    mapSample.y = 0.5;
    mapSample.x = color.r;
    color.r = map.sample(s, mapSample).r;
    mapSample.x = color.g;
    color.g = map.sample(s, mapSample).g;
    mapSample.x = color.b;
    color.b = map.sample(s, mapSample).b;

    texel.rgb = color;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
