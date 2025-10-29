//
//  AlertControllerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools
// ChimpionAlertController 测试视图控制器
class AlertControllerTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色
        view.backgroundColor = .white
        
        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "ChimpionAlertController 测试"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 创建测试按钮
        let testButton = UIButton(type: .system)
        testButton.setTitle("显示ChimpionAlertController", for: .normal)
        testButton.backgroundColor = .systemBlue
        testButton.setTitleColor(.white, for: .normal)
        testButton.layer.cornerRadius = 8
        testButton.translatesAutoresizingMaskIntoConstraints = false
        testButton.addTarget(self, action: #selector(showAlertController), for: .touchUpInside)
        view.addSubview(testButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 250),
            testButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func showAlertController() {
        // 创建基本Alert样式的弹窗
        let alertController = ChimpionAlertController(
            title: "提示", 
            message: "这是一个ChimpionAlertController测试示例，演示了如何创建和自定义弹窗。", 
            preferredStyle: ChimpionAlertController.alert
        )
        
        // 添加取消按钮
        let cancelAction = ChimpionAlertAction(title: "取消", style: ChimpionAlertAction.cancel) { action in
            print("用户点击了取消按钮")
        }
        alertController.addAction(cancelAction)
        
        // 添加默认按钮
        let defaultAction = ChimpionAlertAction(title: "确定", style: ChimpionAlertAction.default) { action in
            print("用户点击了确定按钮")
        }
        alertController.addAction(defaultAction)
        
        // 添加破坏性按钮
        let destructiveAction = ChimpionAlertAction(title: "删除", style: ChimpionAlertAction.destructive) { action in
            print("用户点击了删除按钮")
            
            // 显示一个确认删除的Sheet样式弹窗
            let delaySeconds: TimeInterval = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                self.showConfirmSheet()
            }
        }
        alertController.addAction(destructiveAction)
        
        // 设置自定义样式
        alertController.setTitleStyle(font: UIFont.boldSystemFont(ofSize: 18), color: .systemBlue)
        alertController.setMessageStyle(font: UIFont.systemFont(ofSize: 16), color: .darkGray)
        
        // 呈现弹窗
        present(alertController, animated: true, completion: nil)
    }
    
    /// 显示Sheet样式的确认弹窗
    private func showConfirmSheet() {
        let sheetController = ChimpionAlertController(
            title: "确认删除", 
            message: "您确定要执行此操作吗？此操作无法撤销。", 
            preferredStyle: ChimpionAlertController.sheet
        )
        
        // 添加取消按钮
        let cancelAction = ChimpionAlertAction(title: "取消", style: ChimpionAlertAction.cancel) { action in
            print("用户取消了删除操作")
        }
        sheetController.addAction(cancelAction)
        
        // 添加确认按钮
        let confirmAction = ChimpionAlertAction(title: "确认删除", style: ChimpionAlertAction.destructive) { action in
            print("用户确认了删除操作")
            
            // 显示操作成功的提示
            self.showSuccessAlert()
        }
        sheetController.addAction(confirmAction)
        
        // 呈现Sheet样式弹窗
        present(sheetController, animated: true, completion: nil)
    }
    
    /// 显示操作成功提示
    private func showSuccessAlert() {
        let successAlert = ChimpionAlertController(
            title: "操作成功", 
            message: "删除操作已成功完成。", 
            preferredStyle: ChimpionAlertController.alert
        )
        
        // 添加单个确认按钮
        let okAction = ChimpionAlertAction(title: "好的", style: ChimpionAlertAction.default)
        successAlert.addAction(okAction)
        
        // 设置按钮样式
        successAlert.setTitleStyle(font: UIFont.boldSystemFont(ofSize: 18), color: .systemGreen)
        
        // 呈现成功提示
        present(successAlert, animated: true, completion: nil)
    }
}
