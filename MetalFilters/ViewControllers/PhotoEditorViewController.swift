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
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    fileprivate var filterCollectionView: UICollectionView!
    
    fileprivate var toolCollectionView: UICollectionView!
    
    fileprivate var imageView: MTIImageView!
    
    public var originAsset: PHAsset?
    
    fileprivate var originInputImage: MTIImage?
    
    fileprivate var allFilters: [MTFilter.Type] = []
    
    fileprivate var allTools: [FilterToolItem] = []
    
    fileprivate var thumbnails: [String: UIImage] = [:]
    
    fileprivate var adjustFilter = MTBasicAdjustFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = MTIImageView(frame: previewView.bounds)
        imageView.resizingMode = .aspectFill
        imageView.backgroundColor = .clear
        
        previewView.addSubview(imageView)
        allFilters = MTFilterManager.shard.allFilters
        setupFilterCollectionView()
        setupToolDataSource()
        setupToolCollectionView()
    
        guard let asset = originAsset else {
            return
        }
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, _) in
            if let image = image {
                let ciImage = CIImage(cgImage: image.cgImage!)
                let originImage = MTIImage(ciImage: ciImage, isOpaque: true)
                self.originInputImage = originImage
                self.imageView.image = originImage
            }
        }
        
        generateFilterThumbnailForAsset(asset)
// TODO
//        adjustFilter.inputImage = imageView.image
//        adjustFilter.brightness = 1.0
//        imageView.image = adjustFilter.outputImage
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
        guard let image = self.imageView.image,
            let uiImage = MTFilterManager.shard.generate(image: image) else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            let _ = PHAssetCreationRequest.creationRequestForAsset(from: uiImage)
        }) { (success, error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "Photo Saved!", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func setupFilterCollectionView() {
    
        let frame = CGRect(x: 0, y: 0, width: filtersView.bounds.width, height: filtersView.bounds.height - 44)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 104, height: frame.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        filterCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.showsVerticalScrollIndicator = false
        filtersView.addSubview(filterCollectionView)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterPickerCell.self, forCellWithReuseIdentifier: NSStringFromClass(FilterPickerCell.self))
        filterCollectionView.reloadData()
    }
    
    fileprivate func setupToolCollectionView() {
        let frame = CGRect(x: 0, y: 0, width: filtersView.bounds.width, height: filtersView.bounds.height - 44)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 98, height: frame.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        toolCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        toolCollectionView.backgroundColor = .clear
        toolCollectionView.showsHorizontalScrollIndicator = false
        toolCollectionView.showsVerticalScrollIndicator = false
        toolCollectionView.dataSource = self
        toolCollectionView.delegate = self
        toolCollectionView.register(ToolPickerCell.self, forCellWithReuseIdentifier: NSStringFromClass(ToolPickerCell.self))
        toolCollectionView.reloadData()
    }
    
    fileprivate func setupToolDataSource() {
        allTools.removeAll()
        allTools.append(FilterToolItem(type: .adjust))
        allTools.append(FilterToolItem(type: .brightness))
        allTools.append(FilterToolItem(type: .contrast))
        allTools.append(FilterToolItem(type: .structure))
        allTools.append(FilterToolItem(type: .warmth))
        allTools.append(FilterToolItem(type: .saturation))
        allTools.append(FilterToolItem(type: .color))
        allTools.append(FilterToolItem(type: .fade))
        allTools.append(FilterToolItem(type: .highlights))
        allTools.append(FilterToolItem(type: .vignette))
        allTools.append(FilterToolItem(type: .tiltShift))
        allTools.append(FilterToolItem(type: .sharpen))
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
                        self.filterCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        addCollectionView(at: 0)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        addCollectionView(at: 1)
    }
    
    fileprivate func addCollectionView(at index: Int) {
        let isFilterTabSelected = index == 0
        if isFilterTabSelected && filterButton.isSelected {
            return
        }
        if !isFilterTabSelected && editButton.isSelected {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            if isFilterTabSelected {
                self.toolCollectionView.removeFromSuperview()
                self.filtersView.addSubview(self.filterCollectionView)
            } else {
                self.filterCollectionView.removeFromSuperview()
                self.filtersView.addSubview(self.toolCollectionView)
            }
        }) { (finish) in
            self.filterButton.isSelected = isFilterTabSelected
            self.editButton.isSelected = !isFilterTabSelected
        }

    }
    
    fileprivate func showFilterControlView(for tool: FilterToolItem) {
        
    }
    
    fileprivate func valueForFilterControlView(with tool: FilterToolItem) -> Float {
        switch tool.type {
        case .adjust:
            return 0
        case .brightness:
            return adjustFilter.brightness
        case .contrast:
            return adjustFilter.contrast
        case .structure:
            return 0
        case .warmth:
            return adjustFilter.temperature
        case .saturation:
            return adjustFilter.saturation
        case .color:
            return 0
        case .fade:
            return adjustFilter.fade
        case .highlights:
            return adjustFilter.highlights
        case .vignette:
            return adjustFilter.vignette
        case .tiltShift:
            return adjustFilter.tintShadowsIntensity
        case .sharpen:
            return adjustFilter.sharpen
        }
    }
}

extension PhotoEditorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return allFilters.count
        }
        return allTools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FilterPickerCell.self), for: indexPath) as! FilterPickerCell
            let filter = allFilters[indexPath.item]
            cell.update(filter)
            cell.thumbnailImageView.image = thumbnails[filter.name]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ToolPickerCell.self), for: indexPath) as! ToolPickerCell
            let tool = allTools[indexPath.item]
            cell.update(tool)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            let filter = allFilters[indexPath.item].init()
            filter.inputImage = originInputImage
            imageView.image = filter.outputImage
        } else {
            let tool = allTools[indexPath.item]
            showFilterControlView(for: tool)
        }
    }
    
}
