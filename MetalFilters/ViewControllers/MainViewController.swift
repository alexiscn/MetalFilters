//
//  MainViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {

    fileprivate var fetchResult: PHFetchResult<PHAsset>?
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var albumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metal Filters"
        // Do any additional setup after loading the view.
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.loadPhotos()
                }
                break
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    fileprivate func loadPhotos() {
        let option = PHFetchOptions()
        option.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
        let result = PHAsset.fetchAssets(with: option)
        self.fetchResult = result
        
        if let firstAsset = result.firstObject {
            let targetSize = CGSize(width: firstAsset.pixelWidth, height: firstAsset.pixelHeight)
            PHImageManager.default().requestImage(for: firstAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, _) in
                self.photoImageView.image = image
            }
        }
        
        let albumController = AlbumPhotoViewController(dataSource: result)
        albumController.didSelectAssetHandler = { selectedAsset in
            
        }
        albumController.view.frame = albumView.bounds
        albumView.addSubview(albumController.view)
        addChildViewController(albumController)
        albumController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
