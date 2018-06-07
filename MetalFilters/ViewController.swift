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
        
        if1977Filter.inputImage = originImage
        
        imageView.image = if1977Filter.outputImage
    }
    
    fileprivate func setupFilter() {
        
        guard let url = Bundle.main.url(forResource: "FilterAssets", withExtension: "bundle") else {
            return
        }
        let assetBundle = Bundle(url: url)
        
        let if1977FilterMapURL = assetBundle?.url(forResource: "1977map", withExtension: "png")
        
        if1977Filter.mapImage = MTIImage(contentsOf: if1977FilterMapURL!, options: [.SRGB: false], alphaType: .alphaIsOne)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

