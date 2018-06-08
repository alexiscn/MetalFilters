//
//  InstaFilters.metal
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "IFShaderLib.h"
using namespace metalpetal;

namespace metalpetal {
    
    vertex IFVertexOut instagramVertex(const device VertexIn * vertices [[ buffer(0)]],
                                      uint vid [[ vertex_id ]]) {
        IFVertexOut outVertex;
        
        return outVertex;
    }
    
}

fragment float4 toaster(VertexOut vertexIn [[ stage_in ]],
                        texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                        sampler s [[ sampler(0) ]])
{
    return float4(1);
}

fragment float4 sutro(VertexOut vertexIn [[ stage_in ]],
                      texture2d<float, access::sample> inputTexture [[ texture(0) ]],
                      texture2d<float, access::sample> mapTexture [[ texture(2) ]],
                      texture2d<float, access::sample> metalTexture3 [[ texture(3) ]],
                      texture2d<float, access::sample> inputTexture4 [[ texture(4) ]],
                      texture2d<float, access::sample> inputTexture5 [[ texture(5) ]],
                      sampler s [[ sampler(0) ]]) {
    return float4(1);
}





