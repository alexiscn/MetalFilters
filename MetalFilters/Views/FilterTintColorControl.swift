//
//  FilterTintColorControl.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/14.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

class FilterTintColorControl: UIView, UITabBarDelegate {
    
    private let tabBar: UITabBar
    
    private let shadowTabItem: UITabBarItem
    
    private let highlightTabItem: UITabBarItem
    
    private let colorPicker: FilterTintColorPicker
    
    private let slider: HorizontalSliderView
    
    let titleNormalColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    let titleSelectedColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    
    override init(frame: CGRect) {
        
        tabBar = UITabBar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().layer.borderWidth = 1
        tabBar.backgroundColor = UIColor.white
        tabBar.itemPositioning = .fill
        tabBar.isTranslucent = false
        tabBar.shadowImage = nil
        
        shadowTabItem = UITabBarItem(title: "Shadows", image: nil, selectedImage: nil)
        shadowTabItem.titlePositionAdjustment = .zero
        shadowTabItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                                              .foregroundColor: titleNormalColor], for: .normal)
        shadowTabItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                                              .foregroundColor: titleSelectedColor], for: .selected)
        
        highlightTabItem = UITabBarItem(title: "Highlights", image: nil, selectedImage: nil)
        highlightTabItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                                              .foregroundColor: titleNormalColor], for: .normal)
        highlightTabItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                                              .foregroundColor: titleSelectedColor], for: .selected)
        
        
        
        colorPicker = FilterTintColorPicker(frame: .zero)
        slider = HorizontalSliderView(frame: .zero)
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(tabBar)
        addSubview(colorPicker)
//        addSubview(slider)
        
        tabBar.items = [shadowTabItem, highlightTabItem]
        tabBar.selectedItem = shadowTabItem
        tabBar.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tabBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
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
