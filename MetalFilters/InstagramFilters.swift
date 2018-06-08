//
//  InstagramFilters.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

class InstagramFilters {
    
    var filters: [IFFilter] = []
    
    let if1977Filter = IF1977Filter()
    
    let valencialFilter = IFValenciaFilter()
    
    let amaroFilter = IFAmaroFilter()
    
    init() {
        
        guard let url = Bundle.main.url(forResource: "FilterAssets", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
                return
        }
        
        func parameterImage(named name: String) -> MTIImage? {
            let url = bundle.url(forResource: name, withExtension: "png")
            return MTIImage(contentsOf: url!, options: [.SRGB: false], alphaType: .alphaIsOne)
        }
    }
    
    
}
