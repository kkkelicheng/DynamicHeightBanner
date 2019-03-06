
# 例子:
```
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

* 不足:
1. 因为弄的复制个数太少了,我这个就复制了一次.所以在图片少的时候不会那么顺畅. SD那个库是复制了500个貌似.我这个后续有需求会优化的
2. 可能有未知bug
