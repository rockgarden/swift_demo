//
//  MUPageControl.swift
//  MUCycleScrollView
//
//  Created by qcm on 17/2/14.
//  Copyright © 2017年 ChengziVR. All rights reserved.
//==========================================
//  这个就简单的封装下，需要自定义的小伙伴自行发挥吧。
//  可以自定义Dot等，由于时间关系，以后在加上吧
//=========================================

import UIKit

class MUPageControl: UIView {
        
        var currentPageDotColor: UIColor = UIColor.orange {
                
                didSet {
                        self.pageControl.currentPageIndicatorTintColor = currentPageDotColor
                }
        }
        
        var pageDotColor: UIColor = UIColor.darkGray {
        
                didSet {
                        self.pageControl.pageIndicatorTintColor = pageDotColor
                }
        }
        
        var numberOfPages: Int = 0 {  // default is 0
                didSet {
                        pageControl.numberOfPages = numberOfPages
                }
        }
        
        var currentPage: Int = 0 { // default is 0. value pinned to 0..numberOfPages-1
                didSet {
                        pageControl.currentPage = currentPage
                }
        }
        
        func getMinSize(count: Int) -> CGSize
        {
                return self.pageControl.size(forNumberOfPages: count)
        }
        
        lazy var pageControl: UIPageControl = {
                let pageControl: UIPageControl = UIPageControl(frame: self.bounds)
                pageControl.numberOfPages = self.numberOfPages
                pageControl.currentPage = self.currentPage
                pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
                pageControl.pageIndicatorTintColor = self.pageDotColor
                return pageControl
        }()
        
        override init(frame: CGRect) {
                super.init(frame: frame)
                self.backgroundColor = UIColor.clear
                self.addSubview(self.pageControl)
        }
        
        required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
        }
        
        override func layoutSubviews() {
                super.layoutSubviews()
                self.pageControl.frame = self.bounds
        }

}
