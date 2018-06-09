//
//  IFHudsonFilter.metal
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/8.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
using namespace metalpetal;

float4 hudsonFragment(VertexOut vertexIn [[stage_in]],
                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                      texture2d<float, access::sample> blowout [[ texture(1) ]],
                      texture2d<float, access::sample> map [[ texture(2) ]],
                      texture2d<float, access::sample> overlay [[ texture(3) ]],
                      sampler textureSampler [[ sampler(0) ]])
{
//    float4 texel = texture2D(s_texture, sourceTextureCoordinate);vec4 inputTexel = texel;vec3 bbTexel = texture2D(blowout, textureCoordinate).rgb;
//
//    texel.r = texture2D(overlay, vec2(bbTexel.r, texel.r)).r;
//    texel.g = texture2D(overlay, vec2(bbTexel.g, texel.g)).g;
//    texel.b = texture2D(overlay, vec2(bbTexel.b, texel.b)).b;
//
//    vec3 mapped;
//    mapped.r = texture2D(map, vec2(texel.r, .16666)).r;
//    mapped.g = texture2D(map, vec2(texel.g, .5)).g;
//    mapped.b = texture2D(map, vec2(texel.b, .83333)).b;
//
//    texel.rgb = mapped;
//    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
//
//    gl_FragColor = texel;
    
    return float4(1.0);
}

