//
//  AppGuideViewController.swift
//  AppGuideViewController
//
//  Created by nick on 2017/8/6.
//  Copyright © 2017年 nick. All rights reserved.
//

import UIKit

class AppGuideViewController: UIViewController {
    
    //按钮点击事件回调
    typealias ButtonPress = () -> Void
    //滑动事件回调，主要为了滑动到最后一页弹出按钮
    typealias ScrollRightEdge = () -> Void
    
    @IBOutlet var scrollViewPaging: UIScrollView!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    //存放按钮，为了实现弹出按钮效果
    @IBOutlet var viewContainer: UIView!
 
    var backgroundImages = [UIImage]()
    var backgroundViews = [UIImageView]()
    
    let buttonMargin: CGFloat = 30
    
    /// 给外部设置按钮名称
    var firstBtnName: String?
    var secondBtnName: String?
    
    // 给外部设置按钮背景颜色
    var firstBtnBg: UIColor?
    var secondBtnBg: UIColor?
    
    //点击按钮的回调方法
    var firstBtnPress: ButtonPress?
    var secondBtnPress: ButtonPress?

    //滑动最后边缘的方法
    var scrollRightEdge: ScrollRightEdge?
    
    //给外部设置是否弹出按钮标志
    var isLoading: Bool = false {
        didSet {
            
            if self.viewContainer.isHidden {
                //弹出按钮
                self.viewContainer.isHidden = false
                self.viewContainer.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewContainer.alpha = 1
                })
            }
       
        }
    }
    
    /**
     新增构造方法
     
     - parameter images:        图片数组
     - parameter firsBtnName:   第一个按钮名称
     - parameter secondBtnName: 第二个按钮的名称
     */
    convenience init(images: [UIImage], firsBtnName: String? = nil, secondBtnName: String? = nil, firstBtnBg: UIColor? = nil, secondBtnBg: UIColor? = nil) {
        self.init()
        self.backgroundImages = images
        self.firstBtnName = firsBtnName
        self.secondBtnName = secondBtnName
        self.firstBtnBg = firstBtnBg
        self.secondBtnBg = secondBtnBg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        //默认按钮不显示
        self.viewContainer.isHidden = true
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

// MARK: - 控制器方法
extension AppGuideViewController {
    
    /**
     配置UI
     */
    func setupUI() {
        
        self.addBackgroundViews()
        
        self.addScrollViewPaging()
        
        self.addPageControl()
        
        self.addUserButton()
        
        self.reloadPages()
    }
    
    /**
     添加滚动视图
     */
    func addScrollViewPaging() {
        self.scrollViewPaging = UIScrollView(frame: self.view.bounds)
        self.scrollViewPaging.delegate = self
        self.scrollViewPaging.isPagingEnabled = true
        self.scrollViewPaging.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollViewPaging)
    }
    
    /**
     添加背景图片View
     */
    func addBackgroundViews() {
        let frame = self.view.bounds
        var tmpArray = [UIImageView]()
        for (idx, obj) in self.backgroundImages.enumerated() {
            let imageView = UIImageView(image: obj)
            imageView.frame = frame
            imageView.tag = idx + 1
            tmpArray.append(imageView)
            self.view.addSubview(imageView)
        }
        
        self.backgroundViews = tmpArray
    }
    
    /**
     添加分页控制
     */
    func addPageControl() {
        self.pageControl = UIPageControl(frame:
            CGRect(x: 0, y: self.view.bounds.size.height - 90, width: self.view.bounds.size.width, height: 30))
        self.pageControl.pageIndicatorTintColor = UIColor(hex: 0xe3e8ee)
        self.pageControl.currentPageIndicatorTintColor = UIColor(hex: 0x5d7c9d)
        self.view.addSubview(pageControl)
    }
    
    /**
     添加按钮
     */
    func addUserButton() {
        
        var btnCount: CGFloat = 0
        if self.firstBtnName != nil {
            btnCount = btnCount + 1
        }
        if self.secondBtnName != nil {
            btnCount = btnCount + 1
        }
        
        
        let viewWidth = self.view.bounds.width
        
        self.viewContainer = UIView()
        self.viewContainer.frame =  CGRect(x: self.buttonMargin, y: self.pageControl.frame.origin.y + 40, width:  viewWidth - self.buttonMargin * 2, height: 40)
        self.viewContainer.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.viewContainer)
        
        //计算位置
        let buttonWidth = (self.viewContainer.frame.size.width - buttonMargin * (btnCount - 1)) / btnCount
        var offsetX: CGFloat = 0
        
        var frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 40)
        
        if self.firstBtnName != nil {
            self.firstButton = UIButton(type: UIButtonType.custom)
            self.firstButton.setTitle(self.firstBtnName!, for: UIControlState.normal)
            self.firstButton.layer.cornerRadius = 2;
            self.firstButton.layer.masksToBounds = true
            self.firstButton.setBackgroundImage(UIColor.imageWithColor(self.firstBtnBg!), for: UIControlState.normal)
            self.firstButton.frame = frame
            self.firstButton.addTarget(self, action: #selector(self.handleFristBtnPress(sender:)), for: UIControlEvents.touchUpInside)
            self.viewContainer.addSubview(self.firstButton)
            offsetX = self.firstButton.frame.size.width
        }
        
        if self.secondBtnName != nil {
            self.secondButton = UIButton(type: UIButtonType.custom)
            self.secondButton.setTitle(self.secondBtnName!, for: UIControlState.normal)
            self.secondButton.layer.cornerRadius = 2;
            self.secondButton.layer.masksToBounds = true
            self.secondButton.setBackgroundImage(UIColor.imageWithColor(self.secondBtnBg!),
                                                 for: UIControlState.normal)
            self.secondButton.addTarget(self, action: #selector(self.handleSecondBtnPress(sender:)), for: UIControlEvents.touchUpInside)
            //计算位置
            frame = CGRect(x: offsetX + buttonMargin, y: 0, width: buttonWidth, height: 40)
            self.secondButton.frame = frame
            self.viewContainer.addSubview(self.secondButton)
        }
    }
    
    /**
     刷新数据
     */
    func reloadPages() {
        self.pageControl.numberOfPages = self.numberOfPagesInScrollViewPaging()
        self.scrollViewPaging.contentSize = self.contentSizeOfScrollView()
        
        var x: CGFloat = 0
        
        for (_, obj) in self.backgroundViews.enumerated() {
            obj.frame = obj.frame.offsetBy(dx: x, dy: 0)
            self.scrollViewPaging.addSubview(obj)
            x = x + obj.frame.size.width
        }
        
        //设置如果只有一张图片时不滑动
        if self.scrollViewPaging.contentSize.width == self.scrollViewPaging.frame.size.width {
            self.scrollViewPaging.contentSize = CGSize(width: self.scrollViewPaging.contentSize.width + 1, height: self.scrollViewPaging.contentSize.height)
        }
    }
    
    /**
     分页总数
     */
    func numberOfPagesInScrollViewPaging() -> Int {
        return self.backgroundImages.count
    }
    
    /**
     内容
     
     - returns:
     */
    func contentSizeOfScrollView() -> CGSize {
        let view = self.backgroundViews[0]
        return CGSize(width: view.frame.size.width * CGFloat(self.numberOfPagesInScrollViewPaging()), height: view.frame.size.height)
    }
    
    /**
     点击第一个按钮
     
     - parameter sender:
     */
    func handleFristBtnPress(sender: AnyObject?) {
        self.firstBtnPress?()
    }
    
    /**
     点击第二个按钮
     
     - parameter sender:
     */
    func handleSecondBtnPress(sender: AnyObject?) {
        self.secondBtnPress?()
    }
}

// MARK: - 实现滚动代理
extension AppGuideViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index: Int = Int(scrollView.contentOffset.x / self.view.frame.size.width)
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.x - CGFloat(index) * self.view.frame.size.width) / self.view.frame.size.width)
        
        if self.backgroundViews.count > index {
            let v = self.backgroundViews[index]
            v.alpha = alpha
        }
        
        self.pageControl.currentPage = 0
        
        self.pageControl.currentPage = Int(scrollView.contentOffset.x / (scrollView.contentSize.width / CGFloat(self.numberOfPagesInScrollViewPaging())))
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.pageControl.currentPage == self.numberOfPagesInScrollViewPaging() - 1 {
            self.scrollRightEdge?()
        }
    }
    

}
