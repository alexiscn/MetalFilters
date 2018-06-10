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
    
    fileprivate var originAsset: PHAsset?
    
    fileprivate var allFilters: [MTFilter.Type] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFilterCollectionView()

        //guard let image = UIImage(named: "IMG_8957.JPG") else {
        //    return
        //}
        //let originImage = MTIImage(cgImage: image.cgImage!, options: [.SRGB: false], alphaType: .alphaIsOne).oriented(.right)
        //imageView.image = originImage
        //filter?.moonFilter.inputImage = originImage
        //imageView.image = filter?.moonFilter.outputImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupFilterCollectionView() {
    
        let frame = CGRect(x: 0, y: 0, width: filtersView.bounds.width, height: filtersView.bounds.height - 44)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 104, height: frame.width)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        filtersView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterPickerCell.self, forCellWithReuseIdentifier: NSStringFromClass(FilterPickerCell.self))
    }
    
    fileprivate func generateFilterThumbnailForImage() {
        //generateFilterPreviewThumbnailsForImage
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
