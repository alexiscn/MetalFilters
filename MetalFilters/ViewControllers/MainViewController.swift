//
//  MainViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos
import Metal
import MetalKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var albumView: UIView!
    fileprivate var scrollView: MTScrollView!
    fileprivate var selectedAsset: PHAsset?
    
    fileprivate var albumController: AlbumPhotoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metal Filters"
        
        setupScrollView()
        requestPhoto()
        test()
    }
    
    private func test() {
        
    }
    
    private func setupScrollView() {
        scrollView = MTScrollView(frame: photoView.bounds)
        photoView.addSubview(scrollView)
    }
    
    fileprivate func requestPhoto() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().register(self)
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
        let options = PHFetchOptions()
        options.wantsIncrementalChangeDetails = false
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        if let firstAsset = result.firstObject {
            loadImageFor(firstAsset)
        }
        
        if let controller = albumController {
            controller.update(dataSource: result)
        } else {
            let albumController = AlbumPhotoViewController(dataSource: result)
            albumController.didSelectAssetHandler = { [weak self] selectedAsset in
                self?.loadImageFor(selectedAsset)
            }
            albumController.view.frame = albumView.bounds
            albumView.addSubview(albumController.view)
            addChild(albumController)
            albumController.didMove(toParent: self)
            self.albumController = albumController
        }
    }
    
    fileprivate func loadImageFor(_ asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options) { (image, _) in
            DispatchQueue.main.async {
                self.scrollView.image = image
            }
        }
        selectedAsset = asset
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
            return
        }
        editorController.croppedImage = scrollView.croppedImage
        
        navigationController?.pushViewController(editorController, animated: false)
    }
    
}

extension MainViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.loadPhotos()
    }
}
