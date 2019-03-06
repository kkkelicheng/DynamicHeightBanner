
# 说点什么
这个是项目中要一个变高的banner
于是手写了一个.没做过多的通用接口
实现是用collectionView

# 使用
下载项目,然后拖入`DynamicHeightBannerLib`这个文件夹就好了


# 例子:
```
//当然你可以去继承DyBannerModel, DyBannerModel当前只关心imageUrl和默认的高度.

let b1 = DyBannerModel(imageUrl: "", initialHeight: 200)
let b2 = DyBannerModel(imageUrl: "", initialHeight: 600)
let b3 = DyBannerModel(imageUrl: "", initialHeight: 400)
let banner = DyHeightBannerView(frame: .zero)
view.addSubview(banner)
banner.snp.makeConstraints { (maker) in
    maker.left.right.equalToSuperview()
    maker.top.equalToSuperview().offset(100)
}
banner.bannerDataSource = [b1,b2,b3]

//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            b1.dy_height = 300
//            b2.dy_height = 500
//            b3.dy_height = 700
//        }


```


同样的,初始化以后进行后续设置bannerDataSource也可以的

## 效果图
![效果图](https://github.com/kkkelicheng/DynamicHeightBanner/blob/master/DynamicHeightBanner/bannnner.gif)

-----

![效果图](https://github.com/kkkelicheng/DynamicHeightBanner/blob/master/DynamicHeightBanner/imagebanner.gif)


## 不足:
1. 因为弄的复制个数太少了,我这个就复制了一次.所以在图片少的时候不会那么顺畅. SD那个库是复制了500个貌似.我这个后续有需求会优化的
2. 因为项目不要求自动滚动, 目前没有支持自动滚动

## 可能有未知bug
欢迎来issue 

