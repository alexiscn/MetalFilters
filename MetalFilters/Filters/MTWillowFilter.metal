//
//  MTWillowFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTWillowFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> borderTexture [[ texture(1) ]], 
    texture2d<float, access::sample> glowMap [[ texture(2) ]], 
    texture2d<float, access::sample> map [[ texture(3) ]], 
    texture2d<float, access::sample> overlayMap [[ texture(4) ]], 
    texture2d<float, access::sample> softLightMap [[ texture(5) ]], 
    texture2d<float, access::sample> vignette [[ texture(6) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // Desaturate
    texel.rgb = float3(dot(texel.rgb, float3(.299, .587, .114)));

    // Overlay the glow map
    float3 glowMapTexel = glowMap.sample(s, vertexIn.textureCoordinate).rgb;

    texel.r = overlayMap.sample(s, float2(texel.r, glowMapTexel.r)).r;
    texel.g = overlayMap.sample(s, float2(texel.g, glowMapTexel.g)).g;
    texel.b = overlayMap.sample(s, float2(texel.b, glowMapTexel.b)).b;

    // Soft light the vignette
    float3 vignetteTexel = vignette.sample(s, vertexIn.textureCoordinate).rgb;

    // Add the border, if necessary
    float3 borderShade = float3(0.0,0.0,0.0);

    // Only apply border to the edge pixels, within 20/1024 (0.01953125) of the image's edge
    // This constant cooresponds to a 20 pixel border in the original 1024x1024 assets (lenardot)
    // left edge
    if (vertexIn.textureCoordinate.x <= 0.01953125) {
        float normalized = vertexIn.textureCoordinate.x / 0.01953125;
        borderShade += borderTexture.sample(s, float2(normalized, 0.5)).rgb;
    }
    // right edge
    if (vertexIn.textureCoordinate.x >= 0.98046875) {
        float normalized = (1.0 - vertexIn.textureCoordinate.x) / 0.01953125;
        borderShade += borderTexture.sample(s, float2(normalized, 0.5)).rgb;
    }
    // bottom edge
    if (vertexIn.textureCoordinate.y <= 0.01953125) {
        float normalized = vertexIn.textureCoordinate.y / 0.01953125;
        borderShade += borderTexture.sample(s, float2(normalized, 0.5)).rgb;
    }
    // top edge
    if (vertexIn.textureCoordinate.y >= 0.98046875) {
        float normalized = (1.0 - vertexIn.textureCoordinate.y) / 0.01953125;
        borderShade += borderTexture.sample(s, float2(normalized, 0.5)).rgb;
    }

    vignetteTexel.r = vignetteTexel.r + borderShade.r;
    vignetteTexel.g = vignetteTexel.g + borderShade.g;
    vignetteTexel.b = vignetteTexel.b + borderShade.b;

    texel.r = softLightMap.sample(s, float2(texel.r, vignetteTexel.r)).r;
    texel.g = softLightMap.sample(s, float2(texel.g, vignetteTexel.g)).g;
    texel.b = softLightMap.sample(s, float2(texel.b, vignetteTexel.b)).b;

    // Curves
    float2 lookup;
    lookup.y = 0.5;
    lookup.x = texel.r; // Can do only one lookup because it's monochromatic at this pt. r=g=b
    texel.rgb = map.sample(s, lookup).rgb;
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
