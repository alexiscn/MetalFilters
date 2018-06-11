//
//  PhotoEditorViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos
import MetalPetal

class PhotoEditorViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var filtersView: UIView!
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate var imageView: MTIImageView!
    
    public var originAsset: PHAsset?
    
    fileprivate var originInputImage: MTIImage?
    
    fileprivate var allFilters: [MTFilter.Type] = []
    
    fileprivate var thumbnails: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = MTIImageView(frame: previewView.bounds)
        imageView.resizingMode = .aspectFill
        imageView.backgroundColor = .clear
         
        previewView.addSubview(imageView)
        allFilters = MTFilterManager.shard.allFilters
        setupFilterCollectionView()
    
        guard let asset = originAsset else {
            return
        }
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, _) in
            if let image = image {
                let originImage = MTIImage(cgImage: image.cgImage!, options: [.SRGB: false], alphaType: .alphaIsOne)
                self.originInputImage = originImage
                self.imageView.image = originImage
            }
        }
        
        generateFilterThumbnailForAsset(asset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cancelBarButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveBarButtonTapped(_ sender: Any) {
        
    }
    
    fileprivate func setupFilterCollectionView() {
    
        let frame = CGRect(x: 0, y: 0, width: filtersView.bounds.width, height: filtersView.bounds.height - 44)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 104, height: frame.height)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        filtersView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterPickerCell.self, forCellWithReuseIdentifier: NSStringFromClass(FilterPickerCell.self))
        collectionView.reloadData()
    }
    
    fileprivate func generateFilterThumbnailForAsset(_ asset: PHAsset) {
        DispatchQueue.global().async {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            let targetSize = CGSize(width: 200, height: 200)
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, _) in
                guard let image = image else {
                    return
                }
                for filter in self.allFilters {
                    let image = MTFilterManager.shard.generateThumbnailsForImage(image, with: filter)
                    self.thumbnails[filter.name] = image
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension PhotoEditorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FilterPickerCell.self), for: indexPath) as! FilterPickerCell
        let filter = allFilters[indexPath.item]
        cell.update(filter)
        cell.thumbnailImageView.image = thumbnails[filter.name]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = allFilters[indexPath.item].init()
        filter.inputImage = originInputImage
        imageView.image = filter.outputImage
    }
    
}
