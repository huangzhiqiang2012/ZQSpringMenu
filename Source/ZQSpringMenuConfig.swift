//
//  ZQSpringMenuConfig.swift
//  ZQSpringMenu
//
//  Created by Darren on 2019/3/21.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit

// MARK: 菜单类型,即菜单显示的样式
public enum ZQSpringMenuStyle : Int {
    case normal     = 0          ///< 图片
    case title      = 1          ///< 文字
    case image      = 2          ///< 图片
    case custom     = 3          ///< 自定义视图
}

// MARK: 菜单弹出方向
public enum ZQSpringMenuBloomDirection : Int {
    case top            = 0     ///< 顶部
    case left           = 1     ///< 左边
    case bottom         = 2     ///< 底部
    case right          = 3     ///< 右边
    case topLeft        = 4     ///< 上左
    case topRight       = 5     ///< 上右
    case bottomLeft     = 6     ///< 下左
    case bottomRight    = 7     ///< 下右
}

// MARK: 菜单弹出顺序
public enum ZQSpringMenuBloomOrder : Int {
    case sameTime        = 0    ///< 同时
    case leftToRight     = 1    ///< 从左到右
    case rightToLeft     = 2    ///< 从右到左
}

// MARK: 菜单旋转方向
public enum ZQSpringMenuRotationDirection : Int {
    case right         = 0     ///< 右旋
    case left          = 1     ///< 左旋
}

// MARK: 配置信息
public class ZQSpringMenuConfig: NSObject {
    
    /// 大菜单的半径, 默认 50, 如果 style = .custom, 设置无效
    public var bigMenuRadius : CGFloat = 50
    
    /// 小菜单的半径, 默认 25, 如果 style = .custom, 设置无效
    public var smallMenuRadius : CGFloat = 25
    
    /// 子菜单与父菜单的距离, 默认 20
    /// 这里的距离是指 除了"R+r" 额外的高度，也就是中间空白的距离，如果extraDistance设为0，你将看到它们相切。
    public var extraDistance : CGFloat = 20

    /// 菜单类型,即菜单显示的样式, 默认是 图片
    public var style:ZQSpringMenuStyle = .normal
    
    /// 主题颜色, 默认是 UIColor.red, 如果 style = .custom, 设置无效
    public var themeColor: UIColor = UIColor.red
    
    /// 起始点, 默认是 (100, 100)
    public var origin: CGPoint = CGPoint(x:100, y:100)
    
    /// 菜单数组,包括大菜单按钮和所有小菜单按钮
    /// 注: 默认取第一个作为大菜单按钮
    /// 注: 必须跟 style 对应: .normal, .image -> [UIImage], .title -> [NSAttributedString], .custom -> [UIView]
    public var itemsArr:[AnyObject] = [UIImage]()
    
    /// 弹出方向, 默认是 .top
    public var bloomDirection:ZQSpringMenuBloomDirection = .top
    
    /// 弹出菜单的角度,即第一个和最后一个菜单之间的夹角, 默认 90
    public var bloomAngel:CGFloat = 90
    
    /// 动画时间, 即大菜单旋转时间和小菜单弹出收起时间, 默认 0.25
    public var animateDuration:CGFloat = 0.25
    
    /// 是否弹性弹出,即菜单弹出时是否带弹性动画, 默认是 true
    public var allowBoomSpring:Bool = true
    
    /// 弹簧阻尼, 默认是 0.4, 如果 allowBoomSpring = false, 设置无效
    public var springDamping:CGFloat = 0.4
    
    /// 是否允许大菜单旋转,即弹出小菜单时,大菜单是否旋转
    public var allowBigMenuRotation = true
    
    /// 大菜单旋转角度, 默认是 45, 如果 allowBigMenuRotation = false, 设置无效
    public var bigMenuRotationAngel:CGFloat = 45
    
    /// 大菜单旋转方向, 默认是 .right, 如果 allowBigMenuRotation = false, 设置无效
    public var bigMenuRotationDirection:ZQSpringMenuRotationDirection = .right
    
    /// 菜单弹出顺序, 默认是 .sameTime
    public var bloomOrder:ZQSpringMenuBloomOrder = .sameTime
}
