//
//  IFToasterFilter.metal
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

fragment float4 toasterFragment(VertexOut vertexIn [[ stage_in ]],
                                texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                texture2d<float, access::sample> colorShift [[ texture(1) ]],
                                texture2d<float, access::sample> curves [[ texture(2) ]],
                                texture2d<float, access::sample> metal [[ texture(3) ]],
                                texture2d<float, access::sample> softLight [[ texture(4) ]],
                                texture2d<float, access::sample> vignetteMap [[ texture(5) ]],
                                sampler s [[ sampler(0) ]])
{
    
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    float2 red;
    float2 green;
    float2 blue;
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
    texel.b = vignetteMap.sample(s, lookup).b;

    // Exclusion / Soft light
    lookup.y = .5;
    lookup.x = texel.r;
    texel.r = colorShift.sample(s, lookup).r;
    lookup.x = texel.g;
    texel.g = colorShift.sample(s, lookup).g;
    lookup.x = texel.b;
    texel.b = colorShift.sample(s, lookup).b;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, 1.0);

    return texel;
}
