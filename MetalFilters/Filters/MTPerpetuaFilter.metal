//
//  MTPerpetuaFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTPerpetuaFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> gradient [[ texture(1) ]], 
    texture2d<float, access::sample> lookup [[ texture(2) ]], 
    constant float & strength [[ buffer(0)]], 
    sampler textureSampler [[ sampler(0) ]])
{
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float4 texel = inputTexture.sample(s, vertexIn.textureCoordinate);
    float4 inputTexel = texel;
    // Component wise blending
#define Blend(base, blend, funcf)   float3(funcf(base.r, blend.r), funcf(base.g, blend.g), funcf(base.b, blend.b))
#define BlendOverlayf(base, blend)  (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend)))
#define BlendOverlay(base, blend)   Blend(base, blend, BlendOverlayf)

    texel.rgb = metalColorLookUp(lookup, s, texel.rgb, 33).rgb;

    {
        // grain texture overlay
        float3 grain = gradient.sample(s, vertexIn.textureCoordinate).rgb;
        float3 grained = BlendOverlay(texel.rgb, grain);
        texel.rgb = mix(texel.rgb, grained, 0.35);
    }
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
