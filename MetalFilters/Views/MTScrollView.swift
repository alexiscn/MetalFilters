//
//  MTScrollView.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2019/1/7.
//  Copyright © 2019 shuifeng.me. All rights reserved.
//

import UIKit

class MTScrollView: UIScrollView {

    var image: UIImage? {
        didSet {
            imageView.image = image
            if let image = image {
                zoomScale = 1.0
                minimumZoomScale = 1.0
                maximumZoomScale = 5.0
                imageView.frame.size = actualSizeFor(image)
                contentSize = imageView.bounds.size
                let offset = CGPoint(x: (contentSize.width - bounds.width)/2, y: (contentSize.height - bounds.height)/2)
                setContentOffset(offset, animated: false)
            }
        }
    }
    
    var croppedImage: UIImage? {
        
        guard let image = image else { return nil }
        
        var cropRect = CGRect.zero
        
        let scaleX = image.size.width / contentSize.width
        let scaleY = image.size.height / contentSize.height
        
        cropRect.origin.x = contentOffset.x * scaleX
        cropRect.origin.y = contentOffset.y * scaleY
        cropRect.size.width = image.size.width * bounds.width / contentSize.width
        cropRect.size.height = image.size.height * bounds.height / contentSize.height
        
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private var gridView: MTGridView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        delegate = self
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        
        gridView = MTGridView(frame: bounds)
        gridView.isUserInteractionEnabled = false
        gridView.alpha = 0.0
        addSubview(gridView)
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        press.delegate = self
        press.minimumPressDuration = 0
        addGestureRecognizer(press)
    }
    
    @objc func handlePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                self.gridView.alpha = 1.0
            }
        case .ended:
            UIView.animate(withDuration: 0.2) {
                self.gridView.alpha = 0.0
            }
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actualSizeFor(_ image: UIImage) -> CGSize {
        let viewSize = bounds.size
        
        var actualWidth = image.size.width
        var actualHeight = image.size.height
        var imgRatio = actualWidth/actualHeight
        let viewRatio = viewSize.width/viewSize.height
        
        if imgRatio != viewRatio{
            if(imgRatio > viewRatio){
                imgRatio = viewSize.height / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = viewSize.height
            }
            else{
                imgRatio = viewSize.width / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = viewSize.width
            }
        }
        else {
            imgRatio = viewSize.width / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = viewSize.width
        }
        
        return  CGSize(width: actualWidth, height: actualHeight)
    }
}

extension MTScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gridView.frame = bounds
    }
}

extension MTScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
