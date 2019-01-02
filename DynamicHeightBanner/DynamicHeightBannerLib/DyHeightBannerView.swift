//
//  DyHeightBannerView.swift
//  DynamicHeightBanner
//
//  Created by sun on 2018/12/29.
//  Copyright © 2018年 ShuShangYun. All rights reserved.
//

import UIKit
import SnapKit

class DyHeightBannerView: UIView {

    let pageDotToBannerBottom : CGFloat = 20
    
    lazy var collectionView : UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        c.delegate = self
        c.dataSource = self
        c.isPagingEnabled = true
        c.backgroundColor = .white
        c.showsHorizontalScrollIndicator = true
        c.register(DyHeightBannerCell.self, forCellWithReuseIdentifier: String(describing: DyHeightBannerCell.self))
        return c
    }()
    
    lazy var flowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    var bannerDataSource : [DyBannerModel] = [] {
        didSet{
            blockRefs.removeAll()
            for item in bannerDataSource {
                let block = item.observe(\.dy_height) {[weak self] (model, changedValue) in
                    self?.modelHeightChanged()
                }
                blockRefs.append(block)
            }
            collectionView.reloadData()
        }
    }
    var blockRefs : [NSKeyValueObservation] = []

    
    //默认是屏幕的宽度
    var collectionViewMaxHeight : CGFloat = 0 {
        didSet{
            if collectionViewMaxHeight != oldValue {
                collectionView.snp.updateConstraints { (maker) in
                    maker.height.equalTo(collectionViewMaxHeight)
                }
                setNeedsLayout()
                layoutIfNeeded()
                //内部cell的高度也变化了
                collectionView.reloadData()
            }
            
        }
    }
    
    //自身的高度
    var borderRectHeight : CGFloat = UIScreen.main.bounds.width {
        didSet{
            if borderRectHeight != oldValue {
                self.snp.updateConstraints { (maker) in
                    maker.height.equalTo(borderRectHeight)
                }
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
    
    let dotView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        view.snp.makeConstraints({ (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(20)
        })
        return view
    }()
    
    var scrollIndex : Int {
       return Int(roundf(Float(self.collectionView.contentOffset.x / UIScreen.main.bounds.width)))
    }
    
    //是否需要改变高度
    var shouldChangeHeight:Bool = true
    
    //是否需要改变自身的框高
    var shouldUpdateSelfHeight:Bool = true
    
    var isFirstLoad : Bool = true
    
    //当前滑动到的index
    var currentIndex : Int {
        get {
            if bannerDataSource.count < 1 {
                return 0
            }
            let scrollIndex = self.scrollIndex
            return getRealIndexFromScrollItemIndex(scrollIndex)
        }
    }
    
 //----------------------------------properties end------------------------------------------
    
    
    
    
    
    
    init(frame: CGRect , source:[DyBannerModel] = []) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.bannerDataSource = source
        configSubviews()
        calculateMaxHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubviews(){
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(collectionViewMaxHeight)
        }
        
        addSubview(dotView)
        dotView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-pageDotToBannerBottom)
            maker.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints { (maker) in
            maker.height.equalTo(borderRectHeight)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func calculateMaxHeight(){
        if bannerDataSource.count < 1 {
            collectionViewMaxHeight = UIScreen.main.bounds.width
        }
        else {
            var max = CGFloat.leastNormalMagnitude
            for item in bannerDataSource {
                if item.dy_height > max {
                    max = item.dy_height
                }
            }
            collectionViewMaxHeight = max
        }
    }
    
    func getRealIndexFromScrollItemIndex(_ index:Int) -> Int{
        if index == 0 {
            return self.bannerDataSource.count - 1
        }
        else if index == bannerDataSource.count + 2 - 1 {
            return 0
        }
        else {
            return index - 1
        }
    }
    
    func directScrollToIndex(_ index:Int){
        shouldChangeHeight = false
        collectionView.scrollToItem(at: IndexPath(item:index, section: 0), at: .left, animated: false)
        shouldChangeHeight = true
    }
    
    //模型数据高度变化产生
    func modelHeightChanged(){
        //改变collectionview的高度
        self.calculateMaxHeight()
        //在非drag下变化自己的框高
        if self.shouldUpdateSelfHeight{
            let index = self.currentIndex
            if index < self.bannerDataSource.count {
                let height = self.bannerDataSource[index].dy_height
                self.borderRectHeight = height
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isFirstLoad {
            directScrollToIndex(1)
            isFirstLoad = false
        }
    }
}


extension DyHeightBannerView: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bannerDataSource.count > 0 {
            return bannerDataSource.count + 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing: DyHeightBannerCell.self) , for: indexPath) as! DyHeightBannerCell
        let model = bannerDataSource[getRealIndexFromScrollItemIndex(indexPath.item)]
        cell.setBannerModel(model)
        let colors : [UIColor] = [.cyan , .yellow , .green]
        cell.imageView.backgroundColor = colors[indexPath.row % 3]
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.bounds.width ,height:collectionViewMaxHeight)
    }
    
    
}

extension DyHeightBannerView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //每次需要监听的
        let scroll_w = UIScreen.main.bounds.width;
//        self.scrollIndex = Int(roundf(Float(scrollView.contentOffset.x / scroll_w)))
        
        //不是每次需要监听的
        if shouldChangeHeight {
            let leftIndex = floorf(Float(scrollView.contentOffset.x / scroll_w))
            let rightIndex = ceilf(Float(scrollView.contentOffset.x / scroll_w))
            if leftIndex == rightIndex {
                let realIndex = getRealIndexFromScrollItemIndex(Int(leftIndex))
                let model = bannerDataSource[realIndex]
                print("didEnd scrollViewDidScroll index:\(scrollIndex) realindex:\(realIndex)  model height : \(model.dy_height)")
                self.borderRectHeight = model.dy_height
            }
            else {
                let percent = (scrollView.contentOffset.x - CGFloat(leftIndex) * scroll_w) / scroll_w
                let leftModel = bannerDataSource[getRealIndexFromScrollItemIndex(Int(leftIndex))]
                let rightModel = bannerDataSource[getRealIndexFromScrollItemIndex(Int(rightIndex))]
                let diffSpace = (rightModel.dy_height - leftModel.dy_height) * percent
                let rectHeight = leftModel.dy_height + diffSpace
                print("transition scrollViewDidScroll  index:\(scrollIndex)  rectHeight  : \(rectHeight)")
                self.borderRectHeight = rectHeight
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.scrollIndex == 0 { //现在是第一位 对应的是最后一个数组的位置 ,位置是 totalCount - 2
            directScrollToIndex(bannerDataSource.count + 2 - 2)
        }
        else if self.scrollIndex == bannerDataSource.count + 2 - 1{ //现在是最后一个位置,对应的其实是数组中的第一个数据,也就是第二个cell
            directScrollToIndex(1)
        }
        shouldUpdateSelfHeight = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        shouldUpdateSelfHeight = true
    }

}

