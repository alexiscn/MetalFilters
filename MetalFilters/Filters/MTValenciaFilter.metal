//
//  MTValenciaFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTValenciaFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> gradientMap [[ texture(1) ]], 
    texture2d<float, access::sample> map [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    const float3x3 saturateMatrix = float3x3(1.1402,
                    -0.0598,
                    -0.061,
                    -0.1174,
                    1.0826,
                    -0.1186,
                    -0.0228,
                    -0.0228,
                    1.1772);

    const float3 lumaCoeffs = float3(.3, .59, .11);
    texel.rgb = float3(map.sample(s, float2(texel.r, .1666666)).r,
                     map.sample(s, float2(texel.g, .5)).g,
                     map.sample(s, float2(texel.b, .8333333)).b);

    texel.rgb = saturateMatrix * texel.rgb;

    float luma = dot(lumaCoeffs, texel.rgb);
    texel.rgb = float3(gradientMap.sample(s, float2(luma, texel.r)).r,
                     gradientMap.sample(s, float2(luma, texel.g)).g,
                     gradientMap.sample(s, float2(luma, texel.b)).b);
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
