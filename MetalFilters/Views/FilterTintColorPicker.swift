//
//  FilterTintColorPicker.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

protocol FilterTintColorPickerDelegate {
    
}

class FilterTintColorPicker: UIControl, UIGestureRecognizerDelegate {

    private var boundingBoxes: [CGRect] = []
    
    private let padding: CGFloat = 30.0
    
    private let itemSize: CGFloat = 16.0
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        var elements: [UIAccessibilityElement] = []
        
        let colors = MTTintColor.colors()
        let numberOfColors = colors.count
        let width = frame.width - 2*padding
        let spaceWidth = (width - CGFloat(numberOfColors)*itemSize)/CGFloat(numberOfColors-1)
        for index in 0..<numberOfColors {
            let color = colors[index]
            let x = padding + CGFloat(index)*(spaceWidth + itemSize)
            let rect = CGRect(x: x, y: 75, width: itemSize, height: itemSize)
            boundingBoxes.append(rect)
            
            let accessibilityElement = UIAccessibilityElement(accessibilityContainer: self)
            accessibilityElement.isAccessibilityElement = true
            accessibilityElement.accessibilityFrame = rect
            accessibilityElement.accessibilityLabel = color.displayName
            accessibilityElement.accessibilityHint = "Tap to apply this color. Tap again to adjust strength."
            elements.append(accessibilityElement)
        }
        self.accessibilityElements = elements
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        // TODO
    }
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // layoutIfNeeded
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        //let point = gesture.location(in: self)
        
    }
}
