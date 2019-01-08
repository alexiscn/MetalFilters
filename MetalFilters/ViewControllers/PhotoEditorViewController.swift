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
    
    public var croppedImage: UIImage!
    
    fileprivate var originInputImage: MTIImage?
    fileprivate var adjustFilter = MTBasicAdjustFilter()
    
    fileprivate var allFilters: [MTFilter.Type] = []
    fileprivate var allTools: [FilterToolItem] = []
    fileprivate var thumbnails: [String: UIImage] = [:]
    fileprivate var cachedFilters: [Int: MTFilter] = [:]
    
    /// TODO
    /// It seems that we should have a group to store all filter states
    /// Currently just simply restore to selected filters
    fileprivate var currentSelectFilterIndex: Int = 0
    fileprivate var showUnEditedGesture: UILongPressGestureRecognizer?
    fileprivate var currentAdjustStrengthFilter: MTFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        imageView = MTIImageView(frame: previewView.bounds)
        imageView.resizingMode = .aspectFill
        imageView.backgroundColor = .clear
        previewView.addSubview(imageView)
        allFilters = MTFilterManager.shard.allFilters
        
        setupFilterCollectionView()
        setupToolDataSource()
        setupToolCollectionView()
    
        let ciImage = CIImage(cgImage: croppedImage.cgImage!)
        let originImage = MTIImage(ciImage: ciImage, isOpaque: true)
        originInputImage = originImage
        imageView.image = originImage
        
        generateFilterThumbnails()
        setupNavigationButton()
    }
    
    private func setupNavigationBar() {
        let luxImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        luxImageView.image = UIImage(named: "edit-luxtool")
        navigationItem.titleView = luxImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showUnEditedGesture == nil {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showUnEditPhotoGesture(_:)))
            gesture.minimumPressDuration = 0.02
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationButton() {
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped(_:)))
        let rightBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func clearNavigationButton() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        filterCollectionView.frame.size = filtersView.bounds.size
        toolCollectionView.frame.size = filtersView.bounds.size
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func getFilterAtIndex(_ index: Int) -> MTFilter {
        if let filter = cachedFilters[index] {
            return filter
        }
        let filter = allFilters[index].init()
        cachedFilters[index] = filter
        return filter
    }
    
    @objc func showUnEditPhotoGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .cancelled, .ended:
            let filter = getFilterAtIndex(currentSelectFilterIndex)
            filter.inputImage = originInputImage
            imageView.image = filter.outputImage
            break
        default:
            let filter = getFilterAtIndex(0)
            filter.inputImage = originInputImage
            imageView.image = filter.outputImage
             break
        }
    }
    
    @objc func cancelBarButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func saveBarButtonTapped(_ sender: Any) {
        guard let image = self.imageView.image,
            let uiImage = MTFilterManager.shard.generate(image: image) else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            let _ = PHAssetCreationRequest.creationRequestForAsset(from: uiImage)
        }) { (success, error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "Photo Saved!", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
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
        allTools.append(FilterToolItem(type: .vignette, slider: .zeroToHundred))
        allTools.append(FilterToolItem(type: .tiltShift, slider: .tiltShift))
        allTools.append(FilterToolItem(type: .sharpen, slider: .zeroToHundred))
    }
    
    fileprivate func generateFilterThumbnails() {
        DispatchQueue.global().async {
            
            let size = CGSize(width: 200, height: 200)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            self.croppedImage.draw(in: CGRect(origin: .zero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = scaledImage {
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
        let height = self.filtersView.bounds.height + 44 + view.safeAreaInsets.bottom
        let frame = CGRect(x: 0, y: view.bounds.height - height + 44, width: width, height: height)
    
        let value = valueForFilterControlView(with: tool)
        let controlView = FilterControlView(frame: frame, filterTool: tool, value: value)
        controlView.delegate = self
        filterControlView = controlView
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.addSubview(controlView)
            controlView.setPosition(offScreen: false)
        }) { finish in
            self.title = tool.title
            self.clearNavigationButton()
        }
    }
    
    fileprivate func dismissFilterControlView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.filterControlView?.setPosition(offScreen: true)
        }) { finish in
            self.filterControlView?.removeFromSuperview()
            self.title = "Editor"
            self.setupNavigationButton()
        }
    }
    
    fileprivate func valueForFilterControlView(with tool: FilterToolItem) -> Float {
        switch tool.type {
        case .adjustStrength:
            return 1.0
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
        
        if filterTool.type == .adjustStrength {
            currentAdjustStrengthFilter?.strength = value
            imageView.image = currentAdjustStrengthFilter?.outputImage
            return
        }
        
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
            adjustFilter.tintShadowsColor = .green
            adjustFilter.tintShadowsIntensity = 1
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
        default:
            break
        }
        imageView.image = adjustFilter.outputImage
    }
    
    func filterControlViewDidEndDragging() {
        
    }
    
    func filterControlView(_ controlView: FilterControlView, borderSelectionChangeTo isSelected: Bool) {
        if isSelected {
            let blendFilter = MTIBlendFilter(blendMode: .overlay)
            let filter = getFilterAtIndex(currentSelectFilterIndex)
            blendFilter.inputBackgroundImage = filter.borderImage
            blendFilter.inputImage = imageView.image
            imageView.image = blendFilter.outputImage
        } else {
//            let filter = getFilterAtIndex(currentSelectFilterIndex)
//            filter.inputImage = originInputImage
//            imageView.image = filter.outputImage
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
            if currentSelectFilterIndex == indexPath.item {
                if indexPath.item != 0 {
                    let item = FilterToolItem(type: .adjustStrength, slider: .zeroToHundred)
                    presentFilterControlView(for: item)
                    currentAdjustStrengthFilter = allFilters[currentSelectFilterIndex].init()
                    currentAdjustStrengthFilter?.inputImage = originInputImage
                }
            } else {
                let filter = allFilters[indexPath.item].init()
                filter.inputImage = originInputImage
                imageView.image = filter.outputImage
                currentSelectFilterIndex = indexPath.item
            }
        } else {
            let tool = allTools[indexPath.item]
            presentFilterControlView(for: tool)
        }
    }
    
}
