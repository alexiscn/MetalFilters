//
//  MTBasicAdjustFilter.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/11.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "../Filters/IFShaderLib.h"
using namespace metalpetal;

constant float splines_shadows_offset = 0.250000;
constant float splines_shadowsNeg_offset = 0.750000;

// magnitude can be around the range ~ -1.0 -> 1.0
float3 bowRgbChannels(float3 inVal, float mag) {
    float3 outVal;
    float power = 1.0 + abs(mag);
    if (mag < 0.0) {
        power = 1.0 / power;
    }
    // a bow function that uses a "power curve" to bow the value
    // we flip it so it does more on the high end.
    outVal.r = 1.0 - pow((1.0 - inVal.r), power);
    outVal.g = 1.0 - pow((1.0 - inVal.g), power);
    outVal.b = 1.0 - pow((1.0 - inVal.b), power);
    return outVal;
}

// power bow. at 0 returns a linear curve on the inval.
// at + mag returns an inceasingly "bowed up" curve,
// at - mag returns the symmetrical function across the (y = x) line.
// it's reflected so it's heavier at the bottom.
float powerBow(float inVal, float mag) {
    float outVal;
    float power = 1.0 + abs(mag);
    
    if (mag > 0.0) {
        // flip power, and use abs so it magnitude negative values
        // have curves that are symmetric to positive.
        power = 1.0 / power;
    }
    inVal = 1.0 - inVal;
    outVal = pow((1.0 - inVal), power);
    
    return outVal;
}

float3 adjustTemperature(float tempDelta, float3 inRgb) {
    // we're adjusting the temperature by shifting the chroma channels in yuv space.
    float3 yuvVec;
    // XXX TODO: optimization, move yuvVec to rgbSpace if we use the same curveScale per channel in yuv space.
    
    if (tempDelta > 0.0 ) {
        // "warm" midtone change
        yuvVec =  float3(0.1765, -0.1255, 0.0902);
    } else {
        // "cool" midtone change
        yuvVec = -float3(0.0588,  0.1569, -0.1255);
    }
    float3 yuvColor = rgbToYuv(inRgb);
    
    float luma = yuvColor.r;
    
    float curveScale = sin(luma * 3.14159); // a hump
    
    yuvColor += 0.375 * tempDelta * curveScale * yuvVec;
    inRgb = yuvToRgb(yuvColor);
    return inRgb;
}

float linearRamp(float minVal, float maxVal, float value) {
    return clamp((value - minVal)/(maxVal - minVal), 0.0, 1.0);
}

// Acceptable ranges for strength are (-1, 1)
// Sample output for strength = 0.4: https://www.latest.facebook.com/pxlcld/l743
// When approaching the 1/-1 value the curve approaches a step function
// A negative strength produces an easeOutIn curve.
float easeInOutSigmoid(float value, float strength) {
    float t = 1.0 / (1.0 - strength);
    if (value > 0.5) {
        return 1.0 - pow(2.0 - 2.0 * value, t) * 0.5;
    } else {
        return pow(2.0 * value, t) * 0.5;
    }
}

float3 softOverlayBlend(float3 a, float mag) {
    return pow(a, float3(1.0 / (1.0 - mag)));
}

// shadowsAdjust
// for a passed in luminance curve adjust it by the "shadows area" strong bow or
// the "non shadows area" by the gentle bow function.
// the blurred luminance value is used to determing if we're in a "shadows area"
// or "non shadows area"
// the curves used are here: https://www.facebook.com/pxlcld/l7Dh
float shadowsAdjust(float inLum, float inBlurredLum, float shadowsAmount,
                    texture2d<float, access::sample> splines,
                    sampler textureSampler) {
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float darkVal, brightVal;
    if (shadowsAmount > 0.0) {
        darkVal = splines.sample(s, float2(inLum, splines_shadows_offset)).r;
        brightVal = powerBow(inLum, 0.1);
    } else {
        darkVal = splines.sample(s, float2(inLum, splines_shadowsNeg_offset)).r;
        brightVal = powerBow(inLum, -0.1);
    }
    //float mixVal = clamp((inBlurredLum - 0.00)/0.4, 0.0, 1.0);
    float mixedVal = mix(darkVal, brightVal, inBlurredLum);
    return mix(inLum, mixedVal, abs(shadowsAmount));
}

// highlightsAdjust
// for a passed in luminance curve adjust it by the "highlights area" strong bow or
// the "non highlights area" by the gentle bow function.
// this mirrors the shadowsAdjust implmentation, by mirroring the curves used.
// the curves used are here: https://www.facebook.com/pxlcld/l7Dh
float highlightsAdjust(float inLum, float inBlurredLum, float highlightsAmount,
                       texture2d<float, access::sample> splines,
                       sampler textureSampler) {
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float darkVal, brightVal;
    if (highlightsAmount < 0.0) {
        brightVal = 1.0 - splines.sample(s, float2(1.0 - inLum, splines_shadows_offset)).r;
        darkVal = 1.0 - powerBow(1.0 - inLum, 0.1);
    } else {
        brightVal = 1.0 - splines.sample(s, float2(1.0 - inLum, splines_shadowsNeg_offset)).r;
        darkVal = 1.0 - powerBow(1.0 - inLum, -0.1);
    }
    //float mixVal = clamp((inBlurredLum - 0.6)/0.4, 0.0, 1.0);
    float mixedVal = mix(darkVal, brightVal, inBlurredLum);
    return mix(inLum, mixedVal, abs(highlightsAmount));
}

float3 fadeRaisedSFunction(float3 color) {
    // Coefficients for the fading function
    float3 co1 = float3(-0.9772);
    float3 co2 = float3(1.708);
    float3 co3 = float3(-0.1603);
    float3 co4 = float3(0.2878);
    
    // Components of the polynomial
    float3 comp1 = co1 * pow(float3(color), float3(3.0));
    float3 comp2 = co2 * pow(float3(color), float3(2.0));
    float3 comp3 = co3 * float3(color);
    float3 comp4 = co4;
    
    float3 finalComponent = comp1 + comp2 + comp3 + comp4;
    float3 difference = finalComponent - color;
    float3 scalingValue = float3(0.9);
    
    return color + (difference * scalingValue);
}

// This curve raises the darker colors, to lift shadows.
float3 tintRaiseShadowsCurve(float3 color) {
    // This curve tints only shadows or highlights
    float3 co1 = float3(-0.003671);
    float3 co2 = float3(0.3842);
    float3 co3 = float3(0.3764);
    float3 co4 = float3(0.2515);
    
    // Components of the polynomial
    float3 comp1 = co1 * pow(color, float3(3.0));
    float3 comp2 = co2 * pow(color, float3(2.0));
    float3 comp3 = co3 * color;
    float3 comp4 = co4;
    
    return comp1 + comp2 + comp3 + comp4;
}

// fadeAdjust
// For a passed in float, fade the image between a light gray source and the input image.
float3 fadeAdjust(float3 texel, float fadeVal) {
    float3 faded = fadeRaisedSFunction(texel);
    return (texel * (1.0 - fadeVal)) + (faded * fadeVal);
}

// tintShadows
float3 tintShadows(float3 texel, float3 tintColor, float tintAmount) {
    float3 raisedShadows = tintRaiseShadowsCurve(texel);
    
    // Blend in raised shadows on the channels affected by the tintColor
    float3 tintedShadows = mix(texel, raisedShadows, tintColor);
    float3 tintedShadowsWithAmount = mix(texel, tintedShadows, tintAmount);
    
    // Clamping avoids pixel overflow when both tint shadows and highlights are applied
    return clamp(tintedShadowsWithAmount, 0.0, 1.0);
}

// tintHighlights
float3 tintHighlights(float3 texel, float3 tintColor, float tintAmount) {
    // Apply the inverse of the tint curve to affect highlights
    float3 loweredHighlights = float3(1.0) - tintRaiseShadowsCurve(float3(1.0) - texel);
    
    // Blend in lowered highlights on the channels not effected by the tint colors
    float3 tintedHighlights = mix(texel, loweredHighlights, (float3(1.0) - tintColor));
    float3 tintedHighlightsWithAmount = mix(texel, tintedHighlights, tintAmount);
    
    // Clamping avoids pixel overflow when both tint shadows and highlights are applied
    return clamp(tintedHighlightsWithAmount, 0.0, 1.0);
}

fragment float4 MTBasicAdjustFilterFragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                                      texture2d<float, access::sample> blurred [[ texture(1) ]],
                                      texture2d<float, access::sample> sharpenBlur [[ texture(2) ]],
                                      texture2d<float, access::sample> splines [[ texture(3) ]],
                                      constant float & brightness [[ buffer(0) ]],
                                      constant float & contrast [[ buffer(1) ]],
                                      constant float & saturation [[ buffer(2) ]],
                                      constant float & temperature [[ buffer(3) ]],
                                      constant float & vignette [[ buffer(4) ]],
                                      constant float & fade [[ buffer(5) ]],
                                      constant float & highlights [[ buffer(6) ]],
                                      constant float & shadows [[ buffer(7) ]],
                                      constant float & sharpen [[ buffer(8) ]],
                                      constant float & sharpenDisabled [[ buffer(9) ]],
                                      constant float & tintShadowsIntensity [[ buffer(10) ]],
                                      constant float & tintHighlightsIntensity [[ buffer(11) ]],
                                      constant float3 & tintShadowsColor [[ buffer(12) ]],
                                      constant float3 & tintHighlightsColor [[ buffer(13) ]],
                                      sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    const float TOOL_ON_EPSILON = 0.01;
    
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    
    // sharpen
    if (abs(sharpenDisabled) < TOOL_ON_EPSILON) {
        // A zero value actually does something, a default sharpening, so don't put in a TOOL_ON_EPSILON check here
        float3 blurredTexel = sharpenBlur.sample(s, vertexIn.textureCoordinate).rgb;
        float3 diff = texel.rgb - blurredTexel;
        // sharpen magnitude has a default value of 0.35 at input 0, and a maximum of 2.5 at input 1.0.
        float mag = mix(0.35, 2.5, sharpen);
        texel.rgb = clamp(texel.rgb + diff * mag, 0.0, 1.0);
    }
    
    // highlights and shadows both use a blurred texture
    float blurredLum;
    if ((abs(highlights) > TOOL_ON_EPSILON) ||
        (abs(shadows) > TOOL_ON_EPSILON)) {
        float3 blurredTexel = blurred.sample(s, vertexIn.textureCoordinate).rgb;
        blurredLum = rgb_to_hsv(blurredTexel).z;
    }
    
    // highlights
    if ((abs(highlights) > TOOL_ON_EPSILON)) {
        // highlights tend to look better adjusted in RGB space.
        //                         texel.rgb = hsv_to_rgb(hsv);
        texel.r = highlightsAdjust(texel.r, blurredLum, highlights, splines, textureSampler);
        texel.g = highlightsAdjust(texel.g, blurredLum, highlights, splines, textureSampler);
        texel.b = highlightsAdjust(texel.b, blurredLum, highlights, splines, textureSampler);
    }
    
    //  shadows
    if (abs(shadows) > TOOL_ON_EPSILON) {
        texel.r = shadowsAdjust(texel.r, blurredLum, shadows, splines, textureSampler);
        texel.g = shadowsAdjust(texel.g, blurredLum, shadows, splines, textureSampler);
        texel.b = shadowsAdjust(texel.b, blurredLum, shadows, splines, textureSampler);
    }
    
    // fade
    if (abs(fade) > TOOL_ON_EPSILON ) {
        texel.rgb = fadeAdjust(texel.rgb, fade);
    }
    
    // tint shadows
    if (abs(tintShadowsIntensity) > TOOL_ON_EPSILON) {
        texel.rgb = tintShadows(texel.rgb, tintShadowsColor, tintShadowsIntensity * 2.0);
    }
    
    // tint highlights
    if (abs(tintHighlightsIntensity) > TOOL_ON_EPSILON) {
        texel.rgb = tintHighlights(texel.rgb, tintHighlightsColor, tintHighlightsIntensity * 2.0);
    }
    
    // we're in HSV space for the next bunch of operations
    float3 hsv = rgb_to_hsv(texel.rgb);
    
    // saturation, scale from -1->1 to 50% max adjustment
    if (abs(saturation) > TOOL_ON_EPSILON) {
        float saturationFactor = 1.0 + saturation;
        hsv.y = hsv.y * saturationFactor;
        hsv.y = clamp(hsv.y, 0.0, 1.0);
    }
    
    texel.rgb = hsv_to_rgb(hsv);
    
    // contrast
    if (abs(contrast) > TOOL_ON_EPSILON) {
        float strength = contrast * 0.5; // adjust range to useful values
        
        float3 yuv = rgbToYuv(texel.rgb);
        yuv.x = easeInOutSigmoid(yuv.x, strength);
        yuv.y = easeInOutSigmoid(yuv.y + 0.5, strength * 0.65) - 0.5;
        yuv.z = easeInOutSigmoid(yuv.z + 0.5, strength * 0.65) - 0.5;
        texel.rgb = yuvToRgb(yuv);
    }
    
    // brightness, scale exponent from
    if (abs(brightness) > TOOL_ON_EPSILON) {
        texel.rgb = clamp(texel.rgb, 0.0, 1.0);
        texel.rgb = bowRgbChannels(texel.rgb, brightness * 1.1);
    }
    
    // temperature/tint
    if (abs(temperature) > TOOL_ON_EPSILON) {
        texel.rgb = adjustTemperature(temperature, texel.rgb);
    }
    
    // vignette
    if (abs(vignette) > TOOL_ON_EPSILON ) {
        const float midpoint = 0.7;
        const float fuzziness = 0.62;
        
        float radDist = length(vertexIn.textureCoordinate - 0.5) / sqrt(0.5);
        float mag = easeInOutSigmoid(radDist * midpoint, fuzziness) * vignette * 0.645;
        texel.rgb = mix(softOverlayBlend(texel.rgb, mag), float3(0.0), mag * mag);
    }
    return texel;
}
