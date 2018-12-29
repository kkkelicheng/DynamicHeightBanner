//
//  DyBannerModel.swift
//  DynamicHeightBanner
//
//  Created by sun on 2018/12/29.
//  Copyright © 2018年 ShuShangYun. All rights reserved.
//

import UIKit

@objcMembers class DyBannerModel : NSObject, DyHeightProtocol{
    //初始化的默认值
    dynamic var dy_height: CGFloat
    
    var imageUrl : String = ""
    
    init(imageUrl:String , initialHeight:CGFloat = UIScreen.main.bounds.width) {
        dy_height = initialHeight
        self.imageUrl = imageUrl
    }
}
