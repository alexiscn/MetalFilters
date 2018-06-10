//
//  IFValenciaFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class IFValenciaFilter: IFFilter {
    
    override var borderName: String {
        return "filterBorderPlainWhite.png"
    }
    
    override var samplers: [String : String] {
        return [
            "gradientMap": "valenciaGradientMap.png",
            "map": "valenciaMap.png"
        ]
    }
    
    override var name: String {
        return "Valencia"
    }
    
    override var fragmentName: String {
        return "valencia"
    }
    
}
