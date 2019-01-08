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
    func filterControlView(_ controlView: FilterControlView, didChangeValue value: Float, filterTool: FilterToolItem)
    func filterControlViewDidEndDragging()
    func filterControlView(_ controlView: FilterControlView, borderSelectionChangeTo isSelected: Bool)
}

class FilterControlView: UIView {

    var delegate: FilterControlViewDelegate?
    
    var value: Float = 0
    
    private let cancelButton: UIButton
    private let doneButton: UIButton
    private let titleLabel: UILabel
    private let borderButton: UIButton
    private let sliderView: HorizontalSliderView
    
    private let filterTool: FilterToolItem
    
    init(frame: CGRect, filterTool: FilterToolItem, value: Float = 1.0) {
        
        self.filterTool = filterTool
        
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
        
        sliderView = HorizontalSliderView(frame: CGRect(x: 30, y: frame.height/2 - 50, width: frame.width - 60, height: 70))
        
        borderButton = UIButton(type: .system)
        borderButton.frame.size = CGSize(width: 22, height: 22)
        borderButton.setBackgroundImage(UIImage(named: "filter-border"), for: .normal)
        borderButton.setBackgroundImage(UIImage(named: "filter-border-active"), for: .selected)
        borderButton.tintColor = .clear
        borderButton.isSelected = false
        
        
        super.init(frame: frame)
        
        if filterTool.type == .color {
            //let colorControlView = FilterTintColorControl(frame: frame)
        } else if filterTool.type == .adjust {
            
        } else {
            
        }
        
        sliderView.valueRange = filterTool.slider
        sliderView.slider.value = value
        if filterTool.type == .adjustStrength {
            addSubview(borderButton)
            borderButton.addTarget(self, action: #selector(borderButtonTapped(_:)), for: .touchUpInside)
        }
        
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(sliderView)
        addSubview(cancelButton)
        addSubview(doneButton)
        let buttonHeight: CGFloat = 52
        cancelButton.frame = CGRect(x: 0, y: frame.height - buttonHeight, width: frame.width/2, height: buttonHeight)
        doneButton.frame = CGRect(x: frame.width/2, y: frame.height - buttonHeight, width: frame.width/2, height: buttonHeight)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        sliderView.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonY = frame.height - cancelButton.frame.height - keyWindowSafeAreaInsets.bottom
        cancelButton.frame.origin = CGPoint(x: 0, y: buttonY)
        doneButton.frame.origin = CGPoint(x: frame.width/2, y: buttonY)
        
        if filterTool.type == .adjustStrength {
            sliderView.frame.size = CGSize(width: frame.width - 100, height: 70)
            borderButton.center = CGPoint(x: sliderView.frame.maxX + 30, y: sliderView.center.y)
        }
    }
    
    @objc private func borderButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.filterControlView(self, borderSelectionChangeTo: sender.isSelected)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.filterControlViewDidPressCancel()
    }
    
    @objc private func doneButtonTapped() {
        delegate?.filterControlViewDidPressDone()
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        titleLabel.text = "\(Int(sender.value * 100))"
        
        let trackRect = sender.trackRect(forBounds: sender.bounds)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        let x = thumbRect.origin.x + sender.frame.origin.x + 44
        titleLabel.center = CGPoint(x: x, y: frame.height/2 - 60)
        delegate?.filterControlView(self, didChangeValue: sender.value, filterTool: filterTool)
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
