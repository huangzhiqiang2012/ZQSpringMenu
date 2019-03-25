//
//  ZQSpringMenuController.swift
//  ZQSpringMenuDemo
//
//  Created by Darren on 2019/3/22.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit
import ZQSpringMenu

class ZQSpringMenuController: UIViewController {
    
    var springMenu:ZQSpringMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let config = ZQSpringMenuConfig()
        config.style = .title
        config.origin = CGPoint(x: view.center.x - config.bigMenuRadius, y: 300)
        config.bloomAngel = 120
        
        /// 标题
//        config.itemsArr = [
//            NSAttributedString(string: "首页", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
//            NSAttributedString(string: "音乐", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
//            NSAttributedString(string: "阅读", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
//            NSAttributedString(string: "运动", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
//            NSAttributedString(string: "学习", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
//        ]
        
        /// 图片
        config.themeColor = UIColor.clear
        config.style = .image
        config.bloomOrder = .leftToRight
        config.itemsArr = [
            UIImage(named: "main"),
            UIImage(named: "location"),
            UIImage(named: "music"),
            UIImage(named: "sleep"),
            UIImage(named: "thought"),
        ] as [AnyObject]
        
        /// 自定义视图
//        config.themeColor = UIColor.clear
//        config.style = .custom
//        config.bloomOrder = .leftToRight
//        let main = getButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100), title: "首页")
//        main.addTarget(self, action: #selector(actionForMainButton), for: .touchUpInside)
//        let music = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "音乐")
//        let read = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "阅读")
//        let sport = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "运动")
//        let learn = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "学习")
//
//        config.itemsArr = [
//            main,
//            music,
//            read,
//            sport,
//            learn,
//        ]
        
        springMenu = ZQSpringMenu(config: config)
        springMenu?.delegate = self
        view.addSubview(springMenu!)
    }
}

extension ZQSpringMenuController {
    fileprivate func getButton(frame:CGRect, title:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.blue
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        let width = frame.size.width
        button.layer.cornerRadius = width * 0.5
        button.layer.masksToBounds = true
        return button
    }
}

extension ZQSpringMenuController {
    @objc fileprivate func actionForMainButton() {
        springMenu?.actionForBigMenuButton()
    }
}

extension ZQSpringMenuController : ZQSpringMenuDelegate {
    func springMenu(_ menu: ZQSpringMenu, didSelected index: Int) {
        print("--__--|| \(#function) index: \(index)")
    }
}
