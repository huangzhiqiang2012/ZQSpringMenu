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
    
    @IBOutlet weak var bigMenuRotationDirectionSegmented: UISegmentedControl!
    
    @IBOutlet weak var bloomOrderSegmented: UISegmentedControl!
    
    @IBOutlet weak var styleSegmented: UISegmentedControl!
    
    @IBOutlet weak var themeColorSegmented: UISegmentedControl!
    
    @IBOutlet weak var bloomDirectionSegmented: UISegmentedControl!
    
    @IBOutlet weak var bigMenuRadiusTextField: UITextField!
    
    @IBOutlet weak var smallMenuRadiusTextField: UITextField!
    
    @IBOutlet weak var extraDistanceTextField: UITextField!
    
    @IBOutlet weak var bloomAngelTextField: UITextField!
    
    @IBOutlet weak var animateDurationTextField: UITextField!
    
    @IBOutlet weak var springDampingTextField: UITextField!
    
    @IBOutlet weak var originXTextField: UITextField!
    
    @IBOutlet weak var originYTextField: UITextField!
    
    @IBOutlet weak var bigMenuRotationAngelTextField: UITextField!
    
    @IBOutlet weak var allowBoomSpringSwitch: UISwitch!
    
    @IBOutlet weak var allowBigMenuRotationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        navigationController?.navigationBar.isTranslucent = false
        
        let rightBarButtonItem = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(actionForRightBarButtonItem))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension ZQSpringMenuController {
    @objc fileprivate func actionForRightBarButtonItem() {
        let config = ZQSpringMenuConfig()
        
        config.bigMenuRotationDirection = ZQSpringMenuRotationDirection(rawValue: bigMenuRotationDirectionSegmented.selectedSegmentIndex)!
        
        config.bloomOrder = ZQSpringMenuBloomOrder(rawValue: bloomOrderSegmented.selectedSegmentIndex)!
        
        let style = ZQSpringMenuStyle(rawValue: styleSegmented.selectedSegmentIndex)!
        config.style = style
        switch style {
        case .normal, .image:
            config.itemsArr = [
                UIImage(named: "main"),
                UIImage(named: "location"),
                UIImage(named: "music"),
                UIImage(named: "sleep"),
                UIImage(named: "thought"),
                ] as [AnyObject]
            
        case .title:
            config.itemsArr = [
                NSAttributedString(string: "首页", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
                NSAttributedString(string: "音乐", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
                NSAttributedString(string: "阅读", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
                NSAttributedString(string: "运动", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
                NSAttributedString(string: "学习", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.blue]),
            ]
            
        case .custom:
            let main = getButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100), title: "首页")
            main.addTarget(self, action: #selector(actionForMainButton), for: .touchUpInside)
            let music = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "音乐")
            let read = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "阅读")
            let sport = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "运动")
            let learn = getButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50), title: "学习")
            config.itemsArr = [
                main,
                music,
                read,
                sport,
                learn,
            ]
        }
        
        switch themeColorSegmented.selectedSegmentIndex {
        case 0:
            config.themeColor = UIColor.red
            
        case 1:
            config.themeColor = UIColor.blue
            
        case 2:
            config.themeColor = UIColor.brown
            
        case 3:
            config.themeColor = UIColor.green
            
        default:
            config.themeColor = UIColor.red
        }
        
        config.bloomDirection = ZQSpringMenuBloomDirection(rawValue: bloomDirectionSegmented.selectedSegmentIndex)!
        
        config.bigMenuRadius = CGFloat(((bigMenuRadiusTextField.text ?? "50") as NSString).floatValue)
        
        config.smallMenuRadius = CGFloat(((smallMenuRadiusTextField.text ?? "25") as NSString).floatValue)
        
        config.extraDistance = CGFloat(((extraDistanceTextField.text ?? "20") as NSString).floatValue)
        
        config.bloomAngel = CGFloat(((bloomAngelTextField.text ?? "90") as NSString).floatValue)
        
        config.animateDuration = CGFloat(((animateDurationTextField.text ?? "0.25") as NSString).floatValue)
        
        config.springDamping = CGFloat(((springDampingTextField.text ?? "0.4") as NSString).floatValue)
        
        config.bigMenuRotationAngel = CGFloat(((bigMenuRotationAngelTextField.text ?? "45") as NSString).floatValue)

        config.origin = CGPoint(x: CGFloat(((originXTextField.text ?? "100") as NSString).floatValue),
                                y: CGFloat(((originXTextField.text ?? "100") as NSString).floatValue))
        
        config.allowBoomSpring = allowBoomSpringSwitch.isOn
        
        config.allowBigMenuRotation = allowBigMenuRotationSwitch.isOn
        
        let vc = ZQShowSpringMenuController(config: config)
        navigationController?.pushViewController(vc, animated: true)
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
        
    }
}

