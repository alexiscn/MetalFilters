//
//  MTMayfairFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTMayfairFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> colorOverlay [[ texture(1) ]], 
    texture2d<float, access::sample> glowField [[ texture(2) ]], 
    texture2d<float, access::sample> map [[ texture(3) ]], 
    texture2d<float, access::sample> overlay [[ texture(4) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // saturation

    float luma = dot(texel.rgb, float3(0.2125, 0.7154, 0.0721));
    texel.rgb = mix(float3(luma), texel.rgb, 1.2);

    // curves

    float2 lookup;
    lookup.y = .5;

    lookup.x = texel.r;
    texel.r = map.sample(s, lookup).r;

    lookup.x = texel.g;
    texel.g = map.sample(s, lookup).g;

    lookup.x = texel.b;
    texel.b = map.sample(s, lookup).b;

    // glow

    float3 glowFieldTexel = glowField.sample(s, vertexIn.textureCoordinate).rgb;
    texel.rgb = float3(overlay.sample(s, float2(glowFieldTexel.r, texel.r)).r,
                     overlay.sample(s, float2(glowFieldTexel.g, texel.g)).g,
                     overlay.sample(s, float2(glowFieldTexel.b, texel.b)).b);

    // color

    lookup.x = texel.r;
    texel.r = colorOverlay.sample(s, lookup).r;

    lookup.x = texel.g;
    texel.g = colorOverlay.sample(s, lookup).g;

    lookup.x = texel.b;
    texel.b = colorOverlay.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
