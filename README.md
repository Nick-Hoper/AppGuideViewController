# AppGuideViewController
一种快速集成引导图的控件
#前言
App开发，为了给用户更好的体验，我们都会在首次安装的时候，增加引导图。引导图的设计有很多方式，本文接下来就介绍一种快速集成引导图的方式。先看看效果：
![1.gif](http://upload-images.jianshu.io/upload_images/6618716-34bd48bcb7fdcffb.gif?imageMogr2/auto-orient/strip)

#核心方法
1、提供图片数组、两个点击按钮名称、背景颜色的定制

self.guideViewController = AppGuideViewController(images: coverImageNames,
firsBtnName: "立即体验", secondBtnName: nil,
firstBtnBg: UIColor(hex: 0x43678d), secondBtnBg: nil)

2、两个回调方法.点击按钮后回调，滑动到最后一张图片的时候回调

self.guideViewController?.firstBtnPress = {
() -> Void in
self.window!.rootViewController = vc;
}
self.guideViewController?.scrollRightEdge = {
() -> Void in
self.guideViewController?.isLoading = false
}

3、设计用typealias来定义闭包

typealias ButtonPress = () -> Void      //按钮点击事件回调
typealias ScrollRightEdge = () -> Void      //滑动事件回调，主要为了滑动到最后一页弹出按钮


4、设计一个标志，作为是否弹出按钮的标志

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

5、创建一个容器来放按钮，用来实现弹出按钮效果

let viewWidth = self.view.bounds.width
self.viewContainer = UIView()
self.viewContainer.frame =  CGRect(x: self.buttonMargin, y: self.pageControl.frame.origin.y + 40, width:  viewWidth - self.buttonMargin * 2, height: 40)
self.viewContainer.backgroundColor = UIColor.clear
self.view.addSubview(self.viewContainer)

6、实现滚动代理

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

#最后
以上就是我关于快速构建引导图的一次实践。分享给大家，如果里面有什么错误，欢迎大家多多指教。
完整的代码请查看:[我的github](https://github.com/LuoHongBall/AppGuideViewController.git)
