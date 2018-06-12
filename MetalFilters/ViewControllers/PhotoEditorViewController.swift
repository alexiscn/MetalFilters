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
    
    fileprivate var filterControlView: FilterControlView?
    
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
        allTools.append(FilterToolItem(type: .adjust, slider: .adjustStraighten))
        allTools.append(FilterToolItem(type: .brightness, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .contrast, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .structure, slider: .zeroToHundred))
        allTools.append(FilterToolItem(type: .warmth, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .saturation, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .color, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .fade, slider: .zeroToHundred))
        allTools.append(FilterToolItem(type: .highlights, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .shadows, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .vignette, slider: .negHundredToHundred))
        allTools.append(FilterToolItem(type: .tiltShift, slider: .tiltShift))
        allTools.append(FilterToolItem(type: .sharpen, slider: .zeroToHundred))
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
    
    fileprivate func presentFilterControlView(for tool: FilterToolItem) {
        
        //adjustFilter.inputImage = imageView.image
        adjustFilter.inputImage = originInputImage
        
        let width = self.filtersView.bounds.width
        let height = self.filtersView.bounds.height + 44
        let frame = CGRect(x: 0, y: view.bounds.height - height + 44, width: width, height: height)
        let value = valueForFilterControlView(with: tool)
        let controlView = FilterControlView(frame: frame, filterTool: tool, value: value)
        controlView.delegate = self
        filterControlView = controlView
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.addSubview(controlView)
            controlView.setPosition(offScreen: false)
        }) { finish in
            
        }
    }
    
    fileprivate func dismissFilterControlView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.filterControlView?.setPosition(offScreen: true)
        }) { finish in
            self.filterControlView?.removeFromSuperview()
        }
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
        case .shadows:
            return adjustFilter.shadows
        case .vignette:
            return adjustFilter.vignette
        case .tiltShift:
            return adjustFilter.tintShadowsIntensity
        case .sharpen:
            return adjustFilter.sharpen
        }
    }
}

extension PhotoEditorViewController: FilterControlViewDelegate {
    
    func filterControlViewDidPressCancel() {
        dismissFilterControlView()
    }
    
    func filterControlViewDidPressDone() {
        dismissFilterControlView()
    }
    
    func filterControlViewDidStartDragging() {
        
    }
    
    func filterControlView(_ controlView: FilterControlView, didChangeValue value: Float, filterTool: FilterToolItem) {
        switch filterTool.type {
        case .adjust:
            break
        case .brightness:
            adjustFilter.brightness = value
            break
        case .contrast:
            adjustFilter.contrast = value
            break
        case .structure:
            break
        case .warmth:
            adjustFilter.temperature = value
            break
        case .saturation:
            adjustFilter.saturation = value
            break
        case .color:
            break
        case .fade:
            adjustFilter.fade = value
            break
        case .highlights:
            adjustFilter.highlights = value
            break
        case .shadows:
            adjustFilter.shadows = value
            break
        case .vignette:
            adjustFilter.vignette = value
            break
        case .tiltShift:
            adjustFilter.tintShadowsIntensity = value
        case .sharpen:
            adjustFilter.sharpen = value
        }
        imageView.image = adjustFilter.outputImage
    }
    
    func filterControlViewDidEndDragging() {
        
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
            presentFilterControlView(for: tool)
        }
    }
    
}
