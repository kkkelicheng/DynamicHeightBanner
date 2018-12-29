//
//  ViewController.swift
//  DynamicHeightBanner
//
//  Created by sun on 2018/12/29.
//  Copyright © 2018年 ShuShangYun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blockRef : NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let b1 = DyBannerModel(imageUrl: "", initialHeight: 200)
        let b2 = DyBannerModel(imageUrl: "", initialHeight: 600)
        let b3 = DyBannerModel(imageUrl: "", initialHeight: 400)
        let banner = DyHeightBannerView(frame: .zero, source: [b1,b2,b3])
        view.addSubview(banner)
        banner.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            b1.dy_height = 300
            b2.dy_height = 500
            b3.dy_height = 700
        }
        
        blockRef = b1.observe(\.dy_height, changeHandler: { (model, value) in
            print("blockRefblockRefblockRef ")
        })
    }


}

