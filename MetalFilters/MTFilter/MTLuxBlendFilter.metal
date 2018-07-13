//
//  MTLuxBlendFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTLuxBlendFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                         texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                         texture2d<float, access::sample> antilux [[ texture(1) ]],
                                         texture2d<float, access::sample> starlight [[ texture(2) ]],
                                         constant float & luxBlendAmount [[ buffer(0) ]],
                                         sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    if (luxBlendAmount >= 0.0) {
        texel = mix(texel, starlight.sample(s, vertexIn.textureCoordinate), luxBlendAmount);
    } else {
        texel = mix(texel, antilux.sample(s, vertexIn.textureCoordinate), -luxBlendAmount);
    } 
    return texel;
}
