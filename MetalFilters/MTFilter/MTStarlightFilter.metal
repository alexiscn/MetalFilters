//
//  MTStarlightFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "../Filters/IFShaderLib.h"
using namespace metalpetal;

// see: http://en.wikipedia.org/wiki/Adaptive_histogram_equalization
float clahe2D(texture2d<float, access::sample> cdfTexture, float2 coordinate, float brightness) {
    const float xHalfPix = 0.001953125; // (1.0/256.0)/2.0;
    const float yHalfPix = .03125; // (1.0/16.0)/2.0;
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    brightness = brightness + xHalfPix;
    
    // find the coordinate within the interpolation mesh
    coordinate = clamp(coordinate, 0.125, 1.0 - 0.125001) - 0.125;
    coordinate = coordinate * (3.0 / (1.0-0.125*2.0));
    float2 weight = fract(coordinate);     // the fractional part are our interpolation weights
    coordinate = floor(coordinate);           // floor to get the top-right corner
    
    // compute the 4 corners of the mesh we'll be interpolating
    // tl = top-left, tr = top-right etc
    float tl = float(coordinate.y*4.0 + coordinate.x)/16.0 + yHalfPix;
    float tr = float(coordinate.y*4.0 + coordinate.x + 1.0)/16.0 + yHalfPix;
    float bl = float((coordinate.y + 1.0)*4.0 + coordinate.x)/16.0 + yHalfPix;
    float br = float((coordinate.y + 1.0)*4.0 + coordinate.x + 1.0)/16.0 + yHalfPix;
    
    // obtain the cdf values of the 4 corners
    float4 b1 = cdfTexture.sample(s, float2(brightness, tl));
    float4 b2 = cdfTexture.sample(s, float2(brightness, tr));
    float4 b3 = cdfTexture.sample(s, float2(brightness, bl));
    float4 b4 = cdfTexture.sample(s, float2(brightness, br));
    
    // Commented out for efficiency and subbed in
    //float cdf = cdfColor.r;
    //float cdfMin = cdfColor.b;
    
    // FIXME: this looks wrong!
    float c1 = ((b1.r - b1.b) / (1.0 - b1.b));
    float c2 = ((b2.r - b2.b) / (1.0 - b2.b));
    float c3 = ((b3.r - b3.b) / (1.0 - b3.b));
    float c4 = ((b4.r - b4.b) / (1.0 - b4.b));
    
    // linearly interpolate to obtain the final brightness
    float c1_2 = mix(c1, c2, weight.x);
    float c3_4 = mix(c3, c4, weight.x);
    return mix(c1_2, c3_4, weight.y);
}

fragment float4 MTStarlightFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                         texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                         texture2d<float, access::sample> cdf [[ texture(1) ]],
                                         constant float & filterStrength [[ buffer(0) ]],
                                         sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float3 hsv = rgb_to_hsv(texel.rgb);
    hsv.z = clahe2D(cdf, vertexIn.textureCoordinate, hsv.z);
    hsv.y = min(hsv.y*1.2, 1.0);
    texel.rgb = mix(texel.rgb, hsv_to_rgb(hsv), filterStrength);
    return texel;
}
