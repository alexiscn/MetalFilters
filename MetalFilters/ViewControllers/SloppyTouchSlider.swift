//
//  SloppyTouchSlider.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/12.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

public struct SloppyTouchSliderConfiguration {
    let thumbViewShadowOpacity: CGFloat
    let thumbViewShadowOffset: CGSize
    let thumbViewShadowRadius: CGFloat
    
    let trackShadowOpacity: CGFloat
    let trackShadowOffset: CGSize
    let trackShadowRadius: CGFloat
    let trackHeight: CGFloat
    let defaultTrackColor: UIColor
}

public class SloppyTouchSlider: UIControl {
    
    var trackView: UIView
    
    var highlightedTrackView: UIView
    
    var centerView: UIImageView
    
    var feedbackGenerator: UISelectionFeedbackGenerator
    
    public var value: Double = 0
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    private var sliderPosition: Double!
    private var panValueOrigin: Double!
    private var panOrigin: CGPoint = .zero
    private var config: SloppyTouchSliderConfiguration!
    
    override public init(frame: CGRect) {
        trackView = UIView()
        highlightedTrackView = UIView()
        centerView = UIImageView()
        feedbackGenerator = UISelectionFeedbackGenerator()
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, useTriangularTrack: Bool, configuration: SloppyTouchSliderConfiguration) {
        trackView = UIView()
        highlightedTrackView = UIView()
        centerView = UIImageView()
        feedbackGenerator = UISelectionFeedbackGenerator()
        config = configuration
        super.init(frame: frame)
    }
    
    private func commonInit() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func trackRectForBounds() -> CGRect {
        let bounds = self.bounds
        let height = config.trackHeight
        return .zero
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
}

extension SloppyTouchSlider: UIGestureRecognizerDelegate {
    
}
