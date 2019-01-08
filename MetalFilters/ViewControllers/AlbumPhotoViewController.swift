//
//  AlbumPhotoViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos

class AlbumPhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var didSelectAssetHandler: ((PHAsset) -> Void)?
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate var dataSource: PHFetchResult<PHAsset>
    
    fileprivate var currentSelectIndex: IndexPath?
    
    fileprivate var targetSize: CGSize = .zero
    
    init(dataSource: PHFetchResult<PHAsset>) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let columns = 4
        let itemWidth: CGFloat = (view.frame.width -  CGFloat(columns + 1))/CGFloat(columns)
        targetSize = CGSize(width: itemWidth * UIScreen.main.scale, height: itemWidth * UIScreen.main.scale)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlbumPhotoCell.self, forCellWithReuseIdentifier: NSStringFromClass(AlbumPhotoCell.self))
        view.addSubview(collectionView)
        
        collectionView.reloadData()
        if dataSource.count > 0 {
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        }
    }
    
    public func update(dataSource: PHFetchResult<PHAsset>) {
        DispatchQueue.main.async {
            self.dataSource = dataSource
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = NSStringFromClass(AlbumPhotoCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumPhotoCell
        let asset = dataSource.object(at: indexPath.row)
        cell.assetIdentifier = asset.localIdentifier
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { [unowned cell] (image, _) in
            DispatchQueue.main.async {
                if asset.localIdentifier == cell.assetIdentifier {
                    cell.imageView.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentSelectIndex == indexPath {
            return
        }
        currentSelectIndex = indexPath
        let asset = dataSource.object(at: indexPath.item)
        didSelectAssetHandler?(asset)
    }
}
