//
//  ZQRootViewController.swift
//  ZQSpringMenu
//
//  Created by Darren on 2019/3/21.
//  Copyright © 2019 Darren. All rights reserved.
//

import UIKit


class ZQRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionForNextButton(_ sender: Any) {
        self.navigationController?.pushViewController(ZQSpringMenuController(), animated: true)
    }
}

