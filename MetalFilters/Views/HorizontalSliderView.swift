//
//  HorizontalSliderView.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

/// Slider Value Range
///
/// - zeroToHundred: value in [0, 100]
/// - negHundredToHundred: value in [-100, 100], defaluts to 0
/// - tiltShift: tiltShift
/// - adjustStraighten: adjustStraighten, specially handled
enum SliderValueRange {
    case zeroToHundred
    case negHundredToHundred
    case tiltShift
    case adjustStraighten
}

class HorizontalSliderView: UIView {

    var valueRange: SliderValueRange = .zeroToHundred {
        didSet {
            switch valueRange {
            case .adjustStraighten, .tiltShift:
                break
            case .negHundredToHundred:
                slider.maximumValue = 1
                slider.minimumValue = -1
            case .zeroToHundred:
                slider.maximumValue = 1
                slider.minimumValue = 0
            }
        }
    }
    
    weak var slider: UISlider!
    weak var trackAdjustmentIndicator: UIView!
    
    var value: Float = 0 {
        didSet {
            originValue = value
        }
    }
    
    private weak var trackView: UIView!
    private var feedbackGenerator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    private var originValue: Float = 0
    private var isSliding: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
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
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        self.setNeedsLayout()
        
        if sender.value == sender.minimumValue || sender.value == sender.maximumValue {
            if isSliding {
                feedbackGenerator.selectionChanged()
            }
        }
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        
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
        self.trackView.frame = CGRect(x: trackRect.origin.x, y: trackRect.midY, width: trackRect.width, height: 1)
        
        
        switch valueRange {
        case .zeroToHundred:
            self.trackAdjustmentIndicator.frame = CGRect(x: trackRect.origin.x,
                                                         y: trackRect.midY,
                                                         width: thumbRect.midX,
                                                         height: 1)
        case .negHundredToHundred:
            self.trackAdjustmentIndicator.frame = CGRect(x: trackRect.midX,
                                                         y: trackRect.midY,
                                                         width: thumbRect.midX - trackRect.midX,
                                                         height: 1)
        default:
            break
        }
        
    }

}
