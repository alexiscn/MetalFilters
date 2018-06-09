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
    
    fileprivate var albumController: AlbumPhotoViewController?
    
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
            loadImageFor(firstAsset)
        }
        
        let albumController = AlbumPhotoViewController(dataSource: result)
        albumController.didSelectAssetHandler = { [weak self] selectedAsset in
            self?.loadImageFor(selectedAsset)
        }
        albumController.view.frame = albumView.bounds
        albumView.addSubview(albumController.view)
        addChildViewController(albumController)
        albumController.didMove(toParentViewController: self)
        //self.albumController = albumController
    }
    
    fileprivate func loadImageFor(_ asset: PHAsset) {
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, _) in
            self.photoImageView.image = image
        }
    }
    
    fileprivate func loadImageForEditing(_ asset: PHAsset) {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        asset.requestContentEditingInput(with: options) { (input, info) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
    
}
