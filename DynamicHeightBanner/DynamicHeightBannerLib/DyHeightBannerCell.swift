//
//  DyHeightBannerCell.swift
//  DynamicHeightBanner
//
//  Created by sun on 2018/12/29.
//  Copyright © 2018年 ShuShangYun. All rights reserved.
//

import UIKit
import Kingfisher

class DyHeightBannerCell: UICollectionViewCell {
    var model : DyBannerModel!
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .yellow
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var blockRef : NSKeyValueObservation!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubviews(){
        contentView.addSubview(imageView)
    }
    
    func setBannerModel(_ refreshModel:DyBannerModel){
        self.model = refreshModel
        let url = URL(string: model.imageUrl)
        blockRef = model.observe(\.dy_height, changeHandler: { [weak self](bannerModel, changeValue) in
            print("change value : \(changeValue)")
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        })
        
        //这里发布时候改变下策略
        imageView.kf.setImage(with: url, placeholder: nil, options: [.forceRefresh], progressBlock: nil) {[weak self] (image, error, cacheType, url) in
            if let sSelf = self ,let downImage = image {
                let width = sSelf.bounds.width
                let size = downImage.size
                let height = width / size.width * size.height
                sSelf.model.dy_height = height
            }
        }
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTaped)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.model.dy_height)
        imageView.frame = imageFrame
    }
    
    @objc func imageViewTaped(){
        print("imageViewTaped \(model)")
    }
}
