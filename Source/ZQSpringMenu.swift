//
//  ZQSpringMenu.swift
//  ZQSpringMenu
//
//  Created by Darren on 2019/3/21.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

// MARK: 协议
public protocol ZQSpringMenuDelegate:AnyObject {}

/// 定义在 extension里面的协议方法都是可选的
extension ZQSpringMenuDelegate {
    
    func willPresentSmallMenus(_ menu: ZQSpringMenu) {
        print("--__--|| \(#function)")
    }
    
    func didPresentSmallMenus(_ menu: ZQSpringMenu) {
        print("--__--|| \(#function)")
    }
    
    func willDismissSmallMenus(_ menu: ZQSpringMenu) {
        print("--__--|| \(#function)")
    }
    
    func didDismissSmallMenus(_ menu: ZQSpringMenu) {
        print("--__--|| \(#function)")
    }
    
    /// 如果 style == .custom, 则该代理不会回调
    func springMenu(_ menu: ZQSpringMenu, didSelected index: Int) {
        print("--__--|| \(#function) index: \(index)")
    }
}

// MARK: 弹性按钮视图
public class ZQSpringMenu: UIView {
    
    /// 配置信息
    fileprivate var config: ZQSpringMenuConfig?
    
    /// 是否展开状态
    fileprivate var isOpen: Bool = false
    
    /// 小菜单默认tag
    fileprivate var smallMenuDefaultTag: Int = 100000
    
    /// 小菜单数组
    fileprivate lazy var smallMenusArr:NSMutableArray = {
        let smallMenusArr:NSMutableArray = NSMutableArray()
        return smallMenusArr
    }()
    
    /// 大菜单按钮,懒加载,只有 style != .custom 时才生效
    fileprivate lazy var bigMenuButton: UIButton = {
        let bigMenuButton: UIButton = UIButton(type: .custom)
        if let config = self.config {
            let radius = config.bigMenuRadius
            bigMenuButton.frame = CGRect(x: config.origin.x, y: config.origin.y, width: radius * 2, height: radius * 2)
            bigMenuButton.backgroundColor = config.themeColor
            bigMenuButton.addRadius(radius: radius)
        }
        bigMenuButton.addTarget(self, action: #selector(actionForBigMenuButton), for: .touchUpInside)
        bigMenuView = bigMenuButton
        
        /// 这里是添加在父视图上,因为本身视图是没有大小的
        superview?.addSubview(bigMenuButton)
        return bigMenuButton
    }()
    
    /// 大菜单视图, 如果 style != .custom 时, bigMenuView = bigMenuButton, 如果 style == .custom 时, bigMenuView = config.itemsArr.first
    fileprivate var bigMenuView:UIView = UIView()
    
    /// 代理
    public weak var delegate:ZQSpringMenuDelegate?
    
    // MARK: life cycle
    deinit {
        print("--__--|| \(self.classForCoder) dealloc")
    }
    
    public convenience init(config: ZQSpringMenuConfig?) {
        self.init()
        self.config = config
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupViews()
    }
}

// MARK: private
public extension ZQSpringMenu {
    
    // MARK: 添加视图
    fileprivate func setupViews() {
        guard let config = self.config, let firstObject = config.itemsArr.first  else {
            return
        }
        switch config.style {
        case .normal, .image:
            config.itemsArr.forEach { (object) in
                assert(object.isKind(of: UIImage.self), "object should be UIImage")
            }
            bigMenuButton.setImage((firstObject as! UIImage), for: .normal)
            
            /// 没有小菜单
            if config.itemsArr.count < 2 {
                return
            }
            setupSmallMenu(config: config)
            
        case .title:
            config.itemsArr.forEach { (object) in
                assert(object.isKind(of: NSAttributedString.self), "object should be NSAttributedString")
            }
            bigMenuButton.setAttributedTitle((firstObject as! NSAttributedString), for: .normal)
            
            /// 没有小菜单
            if config.itemsArr.count < 2 {
                return
            }
            setupSmallMenu(config: config)
            
        case .custom:
            config.itemsArr.forEach { (object) in
                assert(object.isKind(of: UIView.self), "object should be UIView")
            }

            /// 没有小菜单
            if config.itemsArr.count < 2 {
                return
            }
            bigMenuView = firstObject as! UIView
            var frame = bigMenuView.frame
            frame.origin.x = config.origin.x
            frame.origin.y = config.origin.y
            bigMenuView.frame = frame
            
            /// 这里是添加在父视图上,因为本身视图是没有大小的
            superview?.addSubview(bigMenuView)
            
            /// 第一个是大菜单
            var menusArr = config.itemsArr
            menusArr.removeFirst()
            smallMenusArr.addObjects(from: menusArr)
            
            for i:Int in 0..<smallMenusArr.count {
                let view:UIView = smallMenusArr[i] as! UIView
                view.center = bigMenuView.center
                
                /// 这里是添加在父视图上,因为本身视图是没有大小的
                superview?.insertSubview(view, belowSubview: bigMenuView)
            }
        }
    }
    
    fileprivate func setupSmallMenu(config:ZQSpringMenuConfig) {
        let smallRadius = config.smallMenuRadius
        
        /// 第一个是大菜单
        for i:Int in 1..<config.itemsArr.count {
            let button = UIButton(type: .custom)
            button.backgroundColor = config.themeColor
            button.center = bigMenuButton.center
            button.bounds = CGRect(x: 0, y: 0, width: smallRadius * 2, height: smallRadius * 2)
            button.addRadius(radius: smallRadius)
            let object = config.itemsArr[i]
            if object.isKind(of: UIImage.self) {
                button.setImage((object as! UIImage), for: .normal)
            }
            else if object.isKind(of: NSAttributedString.self) {
                button.setAttributedTitle((object as! NSAttributedString), for: .normal)
            }
            button.tag = smallMenuDefaultTag + i
            button.addTarget(self, action: #selector(actionForSmallMenuButton(_ :)), for: .touchUpInside)
            smallMenusArr.add(button)
            
            /// 这里是添加在父视图上,因为本身视图是没有大小的
            superview?.insertSubview(button, belowSubview: bigMenuButton)
        }
    }
    
    fileprivate func changeAngelToDegree(angel:CGFloat) -> CGFloat {
        return angel * .pi / 180
    }
    
    fileprivate func createEndPoint(radius:CGFloat, angel:CGFloat) -> CGPoint {
        guard let config = self.config else {
            return CGPoint.zero
        }
        let degree = angel / 180
        switch config.bloomDirection {
        case .top:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 1) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 1) * .pi) * radius)
            
        case .left:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 0.5) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 0.5) * .pi) * radius)
            
        case .bottom:
            return CGPoint(x: bigMenuView.center.x + cos(degree * .pi) * radius,
                           y: bigMenuView.center.y + sin(degree * .pi) * radius)
            
        case .right:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 1.5) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 1.5) * .pi) * radius)
            
        case .topLeft:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 0.75) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 0.75) * .pi) * radius)
            
        case .topRight:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 1.25) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 1.25) * .pi) * radius)
            
        case .bottomLeft:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 0.25) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 0.25) * .pi) * radius)
            
        case .bottomRight:
            return CGPoint(x: bigMenuView.center.x + cos((degree + 1.75) * .pi) * radius,
                           y: bigMenuView.center.y + sin((degree + 1.75) * .pi) * radius)
        }
    }
    
    fileprivate func createBloomAnimation(endPoint:CGPoint, farPoint:CGPoint, nearPoint:CGPoint) -> CAAnimationGroup {
        guard let config = self.config else {
            return CAAnimationGroup()
        }
        let duration = TimeInterval(config.animateDuration)
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0.0, -Double.pi, -Double.pi * 1.5, -Double.pi * 2]
        rotationAnimation.keyTimes = [0.0, 0.3, 0.6, 1.0]
        rotationAnimation.duration = duration
        
        let path = CGMutablePath()
        path.move(to: bigMenuView.center)
        if config.allowBoomSpring {
            path.addLine(to: farPoint)
        }
        path.addLine(to: nearPoint)
        path.addLine(to: endPoint)
        let movingAnimation = CAKeyframeAnimation(keyPath: "position")
        movingAnimation.path = path
        movingAnimation.duration = duration
        movingAnimation.keyTimes = [0.0, 0.5, 0.7, 1.0]
        
        let animations = CAAnimationGroup()
        if config.allowBoomSpring {
            let springAnimation = CASpringAnimation(keyPath: "position")
            springAnimation.beginTime = CACurrentMediaTime() + duration
            springAnimation.damping = config.springDamping
            springAnimation.duration = duration
            springAnimation.fromValue = NSValue(cgPoint: endPoint)
            springAnimation.toValue = NSValue(cgPoint: farPoint)
            animations.animations = [movingAnimation, rotationAnimation, springAnimation]
        }
        else {
            animations.animations = [movingAnimation, rotationAnimation]
        }
        animations.duration = duration
        return animations
    }
    
    fileprivate func createFoldAnimation(endPoint:CGPoint, farPoint:CGPoint) -> CAAnimationGroup {
        guard let config = self.config else {
            return CAAnimationGroup()
        }
        let duration = TimeInterval(config.animateDuration)
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0.0, Double.pi, Double.pi * 2]
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let path = CGMutablePath()
        path.move(to: endPoint)
        if config.allowBoomSpring {
            path.addLine(to: farPoint)
        }
        path.addLine(to: bigMenuView.center)
        let movingAnimation = CAKeyframeAnimation(keyPath: "position")
        movingAnimation.keyTimes = [0.0, 0.75, 1.0]
        movingAnimation.path = path
        movingAnimation.duration = duration
        
        let animations = CAAnimationGroup()
        animations.animations = [movingAnimation, rotationAnimation]
        animations.duration = duration
        return animations
    }
    
    // MARK: 弹出菜单
    fileprivate func bloom() {
        guard let config = self.config else {
            return
        }
        
        /// 大菜单旋转动画
        let duration = TimeInterval(config.animateDuration)
        if config.allowBigMenuRotation {
            UIView.animate(withDuration:duration) {[weak self] in
                if let self = self {
                    var rotationAngle:CGFloat = 0
                    switch config.bigMenuRotationDirection {
                    case .left:
                        rotationAngle = self.changeAngelToDegree(angel: -config.bigMenuRotationAngel)
                        
                    case .right:
                        rotationAngle = self.changeAngelToDegree(angel: config.bigMenuRotationAngel)
                    }
                    self.bigMenuView.transform = CGAffineTransform(rotationAngle: rotationAngle)
                }
            }
        }
        
        /// 小菜单弹出动画
        delegate?.willPresentSmallMenus(self)
        let bigRadius = config.bigMenuRadius
        let smallRadius = config.smallMenuRadius
        let distance = bigRadius + smallRadius + config.extraDistance
        var currentAngel:CGFloat = (180 - config.bloomAngel) * 0.5
        let itemGapAngel:CGFloat = config.bloomAngel / CGFloat((smallMenusArr.count - 1))
        switch config.bloomOrder {
        case .sameTime:
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                let endPoint = createEndPoint(radius: distance, angel: currentAngel)
                let farPoint = createEndPoint(radius: distance + 10, angel: currentAngel)
                let nearPoint = createEndPoint(radius: distance - 5, angel: currentAngel)

                let bloomAnimation = createBloomAnimation(endPoint: endPoint, farPoint: farPoint, nearPoint: nearPoint)
                menu.layer.add(bloomAnimation, forKey: "bloomAnimation")
                menu.center = endPoint
                currentAngel += itemGapAngel
            }
            
        case .leftToRight:
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                let endPoint = createEndPoint(radius: distance, angel: currentAngel)
                UIView.animate(withDuration: duration, delay: duration / Double(smallMenusArr.count) * Double(i), usingSpringWithDamping: config.allowBoomSpring ? config.springDamping : 0, initialSpringVelocity: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.curveEaseIn.rawValue | UIView.AnimationOptions.beginFromCurrentState.rawValue | UIView.AnimationOptions.allowUserInteraction.rawValue), animations: {
                    menu.center = endPoint
                }, completion:nil)
                currentAngel += itemGapAngel
            }
            
        case .rightToLeft:
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                let endPoint = createEndPoint(radius: distance, angel: currentAngel)
                UIView.animate(withDuration: duration, delay: duration / Double(smallMenusArr.count) * Double(smallMenusArr.count - i), usingSpringWithDamping: config.allowBoomSpring ? config.springDamping : 0, initialSpringVelocity: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.curveEaseIn.rawValue | UIView.AnimationOptions.beginFromCurrentState.rawValue | UIView.AnimationOptions.allowUserInteraction.rawValue), animations: {
                    menu.center = endPoint
                }, completion:nil)
                currentAngel += itemGapAngel
            }
        }
        
        isOpen = true
        delegate?.didPresentSmallMenus(self)
    }
    
    // MARK: 折叠菜单
    fileprivate func fold() {
        guard let config = self.config else {
            return
        }
        
        /// 大菜单旋转动画
        let duration = TimeInterval(config.animateDuration)
        if config.allowBigMenuRotation {
            UIView.animate(withDuration: duration) {[weak self] in
                if let self = self {
                    self.bigMenuView.transform = CGAffineTransform.identity
                }
            }
        }
        
        /// 小菜单收起动画
        delegate?.willDismissSmallMenus(self)
        let bigRadius = config.bigMenuRadius
        let smallRadius = config.smallMenuRadius
        let distance = bigRadius + smallRadius + config.extraDistance
        switch config.bloomOrder {
        case .sameTime:
            var currentAngel:CGFloat = (180 - config.bloomAngel) * 0.5
            let itemGapAngel:CGFloat = config.bloomAngel / CGFloat((smallMenusArr.count - 1))
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                let farPoint = createEndPoint(radius: distance + 5, angel: currentAngel)
                
                let foldAnimation = createFoldAnimation(endPoint: menu.center, farPoint: farPoint)
                menu.layer.add(foldAnimation, forKey: "foldAnimation")
                menu.center = bigMenuView.center
                currentAngel += itemGapAngel
            }
            
        case .leftToRight:
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                UIView.animate(withDuration: duration, delay: duration / Double(smallMenusArr.count) * Double(i), options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.curveEaseInOut.rawValue | UIView.AnimationOptions.beginFromCurrentState.rawValue | UIView.AnimationOptions.allowUserInteraction.rawValue), animations: {[weak self] in
                    if let self = self {
                        menu.center = self.bigMenuView.center
                    }
                }, completion:nil)
            }
            
        case .rightToLeft:
            for i:Int in 0..<smallMenusArr.count {
                let menu:UIView = smallMenusArr[i] as! UIView
                UIView.animate(withDuration: duration, delay: duration / Double(smallMenusArr.count) * Double(smallMenusArr.count - i), options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.curveEaseInOut.rawValue | UIView.AnimationOptions.beginFromCurrentState.rawValue | UIView.AnimationOptions.allowUserInteraction.rawValue), animations: {[weak self] in
                    if let self = self {
                        menu.center = self.bigMenuView.center
                    }
                }, completion:nil)
            }
        }
        isOpen = false
        delegate?.didDismissSmallMenus(self)
    }
}

// MARK: action
public extension ZQSpringMenu {
    
    // MARK: 大菜单按钮点击调用方法,用public修饰,自定义视图时,可直接调用该方法
    @objc public func actionForBigMenuButton() {
        isOpen ? fold() : bloom()
    }
    
    @objc fileprivate func actionForSmallMenuButton(_ sender:UIButton) {
        delegate?.springMenu(self, didSelected: sender.tag - smallMenuDefaultTag)
    }
}

// MARK: UIView + extension
extension UIView {
    func addRadius(radius:CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
