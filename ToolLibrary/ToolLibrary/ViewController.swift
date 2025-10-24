//
//  ViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

//@MainActor
class observable<T> : ChimpObservable<T> {
   
}
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let topIconButton = ChimpionButton.button(
//            title: "下载应用",
//            image: UIImage(named: "homeBanner2"),
//            iconPosition: .top,
//            spacing: 0
//        )
//        topIconButton.frame = CGRect(x: 50, y: 200, width: 120, height: 100)
//        topIconButton.setTitleColor(.black, for: .normal)
//        topIconButton.backgroundColor = .systemGreen.withAlphaComponent(0.2)
//        topIconButton.layer.cornerRadius = 12
////        topIconButton.iconSize = CGSize(width: 32, height: 32)
//        topIconButton.addTarget(self, action: #selector(downloadApp), for: .touchUpInside)
//        view.addSubview(topIconButton)
//        // Do any additional setup after loading the view.
//    }
//
//    @objc func downloadApp() {
//        printLog("downloadApp")
//    }
//}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建按钮
        let button1 = ChimpionButton()
        button1.set(title: "左侧图标左侧图标", image: UIImage(named:"homeBanner2"), position: .left, spacing: 8)
        button1.backgroundColor = .systemBlue
        button1.setTitleColor(.white, for: .normal)
        button1.frame = CGRect(x: 50, y: 100, width: 150, height: 44)
        
        let button2 = ChimpionButton()
        button2.set(title: "右侧图标", image: UIImage(named:"homeBanner2"), position: .right, spacing: 8)
        button2.backgroundColor = .systemGreen
        button2.setTitleColor(.white, for: .normal)
        button2.frame = CGRect(x: 50, y: 160, width: 150, height: 44)
        
        let button3 = ChimpionButton()
        button3.set(title: "11", image: UIImage(named:"homeBanner2"), position: .top, spacing: 4)
        button3.backgroundColor = .systemOrange
        button3.setTitleColor(.white, for: .normal)
        button3.frame = CGRect(x: 50, y: 220, width: 120, height: 100)
        
        let button4 = ChimpionButton()
        button4.set(title: "下方图标", image: UIImage(named:"homeBanner2"), position: .bottom, spacing: 4)
        button4.backgroundColor = .systemPurple
        button4.setTitleColor(.white, for: .normal)
        button4.frame = CGRect(x: 50, y: 400, width: 120, height: 60)
        
        // 添加到视图
        [button1, button2, button3, button4].forEach { view.addSubview($0) }
        
        // 添加点击事件
        button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        print("按钮被点击")
    }
}
