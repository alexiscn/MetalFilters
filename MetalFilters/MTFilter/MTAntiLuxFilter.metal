//
//  MTAntiLuxFilter.metal
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
// return the point when the CDF crosses 0.5, the center of mass of the histogram.
// we'll adjust contrast around this point as the center.
float histogramCenter(texture2d<float, access::sample> cdfTexture, float2 coordinate, float brightness) {
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
    
    // obtain the cdf center values of the 4 corners
    float4 b1 = cdfTexture.sample(s, float2(1.0, tl));
    float4 b2 = cdfTexture.sample(s, float2(1.0, tr));
    float4 b3 = cdfTexture.sample(s, float2(1.0, bl));
    float4 b4 = cdfTexture.sample(s, float2(1.0, br));
    
    // the fourth channel, "a", is the histogram midpoint
    
    // linearly interpolate to obtain the final brightness
    float c1_2 = mix(b1.a, b2.a, weight.x);
    float c3_4 = mix(b3.a, b4.a, weight.x);
    return mix(c1_2, c3_4, weight.y);
}

fragment float4 MTAntiLuxFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                          texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                          texture2d<float, access::sample> blurred [[ texture(1) ]],
                                          texture2d<float, access::sample> cdf [[ texture(2) ]],
                                          constant float & filterStrength [[ buffer(0) ]],
                                          sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float3 hsv = rgb_to_hsv(texel.rgb);
    float3 blurredTexel = blurred.sample(s, vertexIn.textureCoordinate).rgb;
    float blurredLum = (blurredTexel.r + blurredTexel.g + blurredTexel.b)/3.0;
    // boost highlights and shadows
    // first with a mask over regions, don't boost a bright pixel in a shadow region or a dark pixel in a highlight region
    float shadowMask = smoothstep(0.5, 0.0, blurredLum); // mask for "shadow areas"
    float highlightMask = smoothstep(0.5, 1.0, blurredLum); // mask for "highlight areas"
    
    // then adjust the luminace curve
    float srcDarkness = smoothstep(0.0, 0.25, hsv.z) * smoothstep(0.5, 0.25, hsv.z); // lerp on how dark this pixel is
    float srcHighlightness = smoothstep(0.50, 0.85, hsv.z); // lery on how bright this pixel is
    hsv.z = hsv.z + srcDarkness * 0.14 * shadowMask;
    hsv.z = hsv.z + srcHighlightness * 0.14 * highlightMask;
    
    // adjust saturation
    hsv.y = min(hsv.y * 0.825, 1.0);
    // adjust contrast centered around the CDF
    float flatBright = histogramCenter(cdf, vertexIn.textureCoordinate, hsv.z);
    hsv.z = mix(hsv.z, flatBright, 0.175);
    
    float3 newRgb = hsv_to_rgb(hsv);
    // fade in a recycled paper gray colored overlay, the max is for a "lighten" blend mode
    newRgb = mix(newRgb, max(newRgb, float3(0.651, 0.615, 0.580)), 0.18);
    texel.rgb = mix(texel.rgb, newRgb, filterStrength);
    
    return texel;
}
