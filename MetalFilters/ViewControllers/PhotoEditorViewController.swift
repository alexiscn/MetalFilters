//
//  PhotoEditorViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import MetalPetal

class PhotoEditorViewController: UIViewController {

    fileprivate var filter: InstagramFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filter = InstagramFilters()
        
        guard let image = UIImage(named: "IMG_8957.JPG") else {
            return
        }
        let originImage = MTIImage(cgImage: image.cgImage!, options: [.SRGB: false], alphaType: .alphaIsOne).oriented(.right)
        //imageView.image = originImage
        
        filter?.moonFilter.inputImage = originImage
        //imageView.image = filter?.moonFilter.outputImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
