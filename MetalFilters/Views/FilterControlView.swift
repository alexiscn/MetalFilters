//
//  FilterControlView.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

protocol FilterControlViewDelegate {
    func filterControlViewDidPressCancel()
    func filterControlViewDidPressDone()
    func filterControlViewDidStartDragging()
    func filterControlView(_ controlView: FilterControlView, didChangeValue value: Float, toolType: FilterToolType)
    func filterControlViewDidEndDragging()
}

class FilterControlView: UIView {

    var delegate: FilterControlViewDelegate?
    
    var value: Float = 0
    
    private let cancelButton: UIButton
    
    private let doneButton: UIButton
    
    private let titleLabel: UILabel
    
    private let slider: SloppyTouchSlider
    
    private let toolType: FilterToolType
    
    init(frame: CGRect, controlType: FilterToolType) {
        
        toolType = controlType
        
        let textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        cancelButton = UIButton(type: .system)
        cancelButton.tintColor = .clear
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(textColor, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        doneButton = UIButton(type: .system)
        doneButton.tintColor = .clear
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        doneButton.setTitleColor(textColor, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        titleLabel.textAlignment = .center
        titleLabel.textColor = textColor
        
        slider = SloppyTouchSlider(frame: .zero)
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(slider)
        addSubview(cancelButton)
        addSubview(doneButton)
        cancelButton.frame = CGRect(x: 0, y: frame.height - 52, width: frame.width/2, height: 52)
        doneButton.frame = CGRect(x: frame.width/2, y: frame.height - 52, width: frame.width/2, height: 52)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.filterControlViewDidPressCancel()
    }
    
    @objc private func doneButtonTapped() {
        delegate?.filterControlViewDidPressDone()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(offScreen isOffScreen: Bool) {
        if isOffScreen {
            frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y + 44)
            alpha = 0
        } else {
            frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - 44)
            alpha = 1
        }
    }
    
}
