//
//  HorizontalSliderView.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class HorizontalSliderView: UIView {

    weak var slider: UISlider!
    
    var isSliding: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    weak var trackAdjustmentIndicator: UIView!
    private weak var trackView: UIView!
    private var feedbackGenerator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    private func setup() {
        let trackView = UIView(frame: .zero)
        trackView.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
        self.addSubview(trackView)
        self.trackView = trackView
        
        let trackAdjustmentIndicator = UIView(frame: .zero)
        trackAdjustmentIndicator.backgroundColor = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1)
        self.addSubview(trackAdjustmentIndicator)
        self.trackAdjustmentIndicator = trackAdjustmentIndicator
        
        let slider = UISlider(frame: self.bounds)
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        self.addSubview(slider)
        self.slider = slider
        
        self.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        self.setNeedsLayout()
        
        if sender.value == sender.minimumValue || sender.value == sender.maximumValue {
            if isSliding {
                feedbackGenerator.selectionChanged()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSliding = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isSliding = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.slider.frame.size = CGSize(width: self.bounds.width, height: self.bounds.height)
        self.slider.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let thumbRect = self.slider.convert(self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: self.slider.trackRect(forBounds: self.slider.bounds), value: self.slider.value), to: self)
        let trackRect = self.slider.convert(self.slider.trackRect(forBounds: self.slider.bounds), to: self)
        self.trackView.frame = CGRect(x: trackRect.origin.x, y: trackRect.origin.y, width: trackRect.width, height: 1) 
        self.trackAdjustmentIndicator.frame = CGRect(x: trackRect.midX, y: trackRect.midY, width: thumbRect.midX - trackRect.midX, height: thumbRect.midY - trackRect.midY)
    }

}
