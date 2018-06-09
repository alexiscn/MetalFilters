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

