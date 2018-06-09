//
//  IFEarlybirdFilter.metal
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
                      texture2d<float, access::sample> curves [[ texture(1) ]],
                      texture2d<float, access::sample> earlybirdMap [[ texture(2) ]],
                      texture2d<float, access::sample> overlayMap [[ texture(2) ]],
                      texture2d<float, access::sample> vignetteMap [[ texture(3) ]],
                      sampler textureSampler [[ sampler(0) ]])
{
//    vec4 texel = texture2D(s_texture, sourceTextureCoordinate);vec4 inputTexel = texel;const mat3 saturate = mat3(1.210300,
//                                                                                                                  -0.089700,
//                                                                                                                  -0.091000,
//                                                                                                                  -0.176100,
//                                                                                                                  1.123900,
//                                                                                                                  -0.177400,
//                                                                                                                  -0.034200,
//                                                                                                                  -0.034200,
//                                                                                                                  1.265800);
//    
//    const vec3 rgbPrime = vec3(0.25098, 0.14640522, 0.0);
//    const vec3 desaturate = vec3(.3, .59, .11);
//    
//    vec2 lookup;
//    lookup.y = 0.5;
//    
//    lookup.x = texel.r;
//    texel.r = texture2D(curves, lookup).r;
//    
//    lookup.x = texel.g;
//    texel.g = texture2D(curves, lookup).g;
//    
//    lookup.x = texel.b;
//    texel.b = texture2D(curves, lookup).b;
//    
//    float desaturatedColor;
//    vec3 result;
//    desaturatedColor = dot(desaturate, texel.rgb);
//    
//    
//    lookup.x = desaturatedColor;
//    result.r = texture2D(overlayMap, lookup).r;
//    lookup.x = desaturatedColor;
//    result.g = texture2D(overlayMap, lookup).g;
//    lookup.x = desaturatedColor;
//    result.b = texture2D(overlayMap, lookup).b;
//    
//    texel.rgb = saturate * mix(texel.rgb, result, .5);
//    
//    vec2 tc = (2.0 * textureCoordinate) - 1.0;
//    float d = dot(tc, tc);
//    
//    vec3 sampled;
//    lookup.y = .5;
//    
//    lookup.x = texel.r;
//    sampled.r = texture2D(vignetteMap, lookup).r;
//    
//    lookup.x = texel.g;
//    sampled.g = texture2D(vignetteMap, lookup).g;
//    
//    lookup.x = texel.b;
//    sampled.b = texture2D(vignetteMap, lookup).b;
//    
//    float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
//    texel.rgb = mix(texel.rgb, sampled, value);
//    
//    lookup.x = texel.r;
//    sampled.r = texture2D(blowout, lookup).r;
//    lookup.x = texel.g;
//    sampled.g = texture2D(blowout, lookup).g;
//    lookup.x = texel.b;
//    sampled.b = texture2D(blowout, lookup).b;
//    texel.rgb = mix(sampled, texel.rgb, value);
//    
//    
//    lookup.x = texel.r;
//    texel.r = texture2D(earlybirdMap, lookup).r;
//    lookup.x = texel.g;
//    texel.g = texture2D(earlybirdMap, lookup).g;
//    lookup.x = texel.b;
//    texel.b = texture2D(earlybirdMap, lookup).b;
//    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
//    
//    gl_FragColor = texel;
    return float4(1.0);
}


