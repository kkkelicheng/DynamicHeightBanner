//
//  DyPageDotView.swift
//  DynamicHeightBanner
//
//  Created by sun on 2019/1/2.
//  Copyright © 2019年 ShuShangYun. All rights reserved.
//

import UIKit

class DyPageDotView: UIView {
    
    var pageControl : UIPageControl!
    
    var currentPage : Int = 0{
        didSet{
            pageControl.currentPage = currentPage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        pageControl = UIPageControl(frame: .zero)
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 0.992, green: 0.518, blue: 0.533, alpha: 1)
        pageControl.pageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = false
    }
    
    func setPageCount(_ count:Int){
        self.pageControl.numberOfPages = count
        currentPage = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
