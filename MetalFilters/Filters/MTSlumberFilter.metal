//
//  MTSlumberFilter.metal
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

fragment float4 MTSlumberFragment(VertexOut vertexIn [[ stage_in ]], 
    texture2d<float, access::sample> inputTexture [[ texture(0) ]], 
    texture2d<float, access::sample> lookup [[ texture(1) ]], 
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
        // bottom dark fill gradient
        float4 gradStart = float4(float3(0.125), 1.0);
        float4 gradEnd  = float4(float3(0.258), 0.0);
        float gradCoord = (1.0 - vertexIn.textureCoordinate.y);

        gradCoord = clamp(gradCoord, 0.0, 1.0);
        float4 gradColor = mix(gradStart, gradEnd, gradCoord);
        float3 gradBlend = BlendOverlay(texel.rgb, gradColor.rgb);
        float gradOpac = 0.3 * gradColor.a;
        texel.rgb = gradOpac * gradBlend + (1.0 - gradOpac) * texel.rgb;
    }
    texel.rgb = mix(inputTexel.rgb, texel.rgb, strength);
    return texel;
}
