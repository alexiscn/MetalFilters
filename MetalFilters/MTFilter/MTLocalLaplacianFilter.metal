//
//  MTLocalLaplacianFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 MTLocalLaplacianFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                               texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                               texture2d<float, access::sample> localLaplacian [[ texture(1) ]],
                                               constant float & filterStrength [[ buffer(0) ]],
                                               sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    
    texel.rgb = texel.rgb + filterStrength * (localLaplacian.sample(s, vertexIn.textureCoordinate).rgb - 0.5);
    return texel;
}
