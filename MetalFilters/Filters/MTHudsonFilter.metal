//
//  MTHudsonFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTHudsonFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> blowout [[ texture(1) ]], 
    texture2d<float, access::sample> map [[ texture(2) ]], 
    texture2d<float, access::sample> overlay [[ texture(3) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float3 bbTexel = blowout.sample(s, vertexIn.textureCoordinate).rgb;

    texel.r = overlay.sample(s, float2(bbTexel.r, texel.r)).r;
    texel.g = overlay.sample(s, float2(bbTexel.g, texel.g)).g;
    texel.b = overlay.sample(s, float2(bbTexel.b, texel.b)).b;

    float3 mapped;
    mapped.r = map.sample(s, float2(texel.r, .16666)).r;
    mapped.g = map.sample(s, float2(texel.g, .5)).g;
    mapped.b = map.sample(s, float2(texel.b, .83333)).b;

    texel.rgb = mapped;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
