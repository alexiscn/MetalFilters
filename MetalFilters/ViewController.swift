//
//  ViewController.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/5.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MetalPetal

class ViewController: UIViewController {

    fileprivate let if1977Filter = IF1977Filter()
    
    fileprivate let valencialFilter = IFValenciaFilter()
    
    @IBOutlet weak var imageView: MTIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let image = UIImage(named: "IMG_8957.JPG") else {
            return
        }
        let originImage = MTIImage(cgImage: image.cgImage!, options: [.SRGB: false], alphaType: .alphaIsOne).oriented(.right)
        imageView.image = originImage
        
        setupFilter()
        
        valencialFilter.inputImage = originImage
        imageView.image = valencialFilter.outputImage
    }
    
    fileprivate func setupFilter() {
        
        guard let url = Bundle.main.url(forResource: "FilterAssets", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
            return
        }
        
        func parameterImage(named name: String) -> MTIImage? {
            let url = bundle.url(forResource: name, withExtension: "png")
            return MTIImage(contentsOf: url!, options: [.SRGB: false], alphaType: .alphaIsOne)
        }
        
        if1977Filter.mapImage = parameterImage(named: "1977map")
        
        valencialFilter.mapImage = parameterImage(named: "valenciaMap")
        valencialFilter.gradientMapImage = parameterImage(named: "valenciaGradientMap")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

