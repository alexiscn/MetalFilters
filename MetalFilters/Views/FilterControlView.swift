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
}

class FilterControlView: UIView {

    var delegate: FilterControlViewDelegate?
    
    var value: Float = 0
    
    private let cancelButton: UIButton
    
    private let doneButton: UIButton
    
    private let titleLabel: UILabel
    
    private let sliderView: HorizontalSliderView
    
    private let filterTool: FilterToolItem
    
    init(frame: CGRect, filterTool: FilterToolItem, value: Float = 0) {
        
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
        
        super.init(frame: frame)
        
        switch filterTool.slider {
        case .adjustStraighten:
            break
        case .negHundredToHundred:
            sliderView.slider.maximumValue = 1
            sliderView.slider.minimumValue = -1
            sliderView.slider.value = value
            break
        case .zeroToHundred:
            sliderView.slider.maximumValue = 1
            sliderView.slider.minimumValue = 0
            sliderView.slider.value = value
            break
        case .tiltShift:
            break
        }
        
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(sliderView)
        addSubview(cancelButton)
        addSubview(doneButton)
        cancelButton.frame = CGRect(x: 0, y: frame.height - 52, width: frame.width/2, height: 52)
        doneButton.frame = CGRect(x: frame.width/2, y: frame.height - 52, width: frame.width/2, height: 52)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        sliderView.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
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
