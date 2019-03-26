//
//  ZQShowSpringMenuController.swift
//  ZQSpringMenuDemo
//
//  Created by Darren on 2019/3/26.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit
import ZQSpringMenu

class ZQShowSpringMenuController: UIViewController {
    
    var config:ZQSpringMenuConfig?
    
    convenience init(config:ZQSpringMenuConfig) {
        self.init()
        self.config = config
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        navigationController?.navigationBar.isTranslucent = false
        
        let menu = ZQSpringMenu(config: config)
        menu.delegate = self
        view.addSubview(menu)
    }
}

extension ZQShowSpringMenuController : ZQSpringMenuDelegate {
    func springMenu(_ menu: ZQSpringMenu, didSelected index: Int) {
        print("--__--|| \(#function) index: \(index)")
    }
}
