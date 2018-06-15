//
//  MTBrannanFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTBrannanFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> blowout [[ texture(1) ]], 
    texture2d<float, access::sample> brannanMap [[ texture(2) ]], 
    texture2d<float, access::sample> contrast [[ texture(3) ]], 
    texture2d<float, access::sample> lumaMap [[ texture(4) ]], 
    texture2d<float, access::sample> screenMap [[ texture(5) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float3x3 saturateMatrix = float3x3(1.105150,
              -0.044850,
              -0.046000,
              -0.088050,
              1.061950,
              -0.089200,
              -0.017100,
              -0.017100,
              1.132900);

    float3 luma = float3(.3, .59, .11);

    float2 lookup;
    lookup.y = 0.5;
    lookup.x = texel.r;
    texel.r = brannanMap.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = brannanMap.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = brannanMap.sample(s, lookup).b;

    texel.rgb = saturateMatrix * texel.rgb;


    float2 tc = (2.0 * vertexIn.textureCoordinate) - 1.0;
    float d = dot(tc, tc);
    float3 sampled;
    lookup.y = 0.5;
    lookup.x = texel.r;
    sampled.r = blowout.sample(s, lookup).r;
    lookup.x = texel.g;
    sampled.g = blowout.sample(s, lookup).g;
    lookup.x = texel.b;
    sampled.b = blowout.sample(s, lookup).b;
    float value = smoothstep(0.0, 1.0, d);
    texel.rgb = mix(sampled, texel.rgb, value);

    lookup.x = texel.r;
    texel.r = contrast.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = contrast.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = contrast.sample(s, lookup).b;


    lookup.x = dot(texel.rgb, luma);
    texel.rgb = mix(lumaMap.sample(s, lookup).rgb, texel.rgb, .5);

    lookup.x = texel.r;
    texel.r = screenMap.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = screenMap.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = screenMap.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
