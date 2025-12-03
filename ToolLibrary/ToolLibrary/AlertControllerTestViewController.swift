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
        
        // 创建Sheet模式测试按钮
        let sheetTestButton = UIButton(type: .system)
        sheetTestButton.setTitle("测试Sheet模式", for: .normal)
        sheetTestButton.backgroundColor = .systemGreen
        sheetTestButton.setTitleColor(.white, for: .normal)
        sheetTestButton.layer.cornerRadius = 8
        sheetTestButton.translatesAutoresizingMaskIntoConstraints = false
        sheetTestButton.addTarget(self, action: #selector(showSheetTest), for: .touchUpInside)
        view.addSubview(sheetTestButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 250),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            
            sheetTestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetTestButton.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 30),
            sheetTestButton.widthAnchor.constraint(equalToConstant: 250),
            sheetTestButton.heightAnchor.constraint(equalToConstant: 50)
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
        
        // 显示弹窗
        alertController.show()
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
        
        // 显示Sheet样式弹窗
        sheetController.show()
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
        
        // 显示成功提示
        successAlert.show()
    }
    
    @objc private func showSheetTest() {
        // 创建Sheet样式的弹窗
        let sheetController = ChimpionAlertController(
            title: "Sheet模式测试", 
            message: "这是一个详细的Sheet模式弹窗示例，包含多种功能按钮。", 
            preferredStyle: ChimpionAlertController.sheet
        )
        
        // 1. 添加默认操作按钮
        let action1 = ChimpionAlertAction(title: "分享", style: ChimpionAlertAction.default) { action in
            print("用户点击了分享按钮")
        }
        sheetController.addAction(action1)
        
        // 2. 添加另一个默认操作按钮
        let action2 = ChimpionAlertAction(title: "保存", style: ChimpionAlertAction.default) { action in
            print("用户点击了保存按钮")
        }
        sheetController.addAction(action2)
        
        // 3. 添加设置按钮
        let action3 = ChimpionAlertAction(title: "设置", style: ChimpionAlertAction.default) { action in
            print("用户点击了设置按钮")
        }
        sheetController.addAction(action3)
        
        // 4. 添加更多选项按钮
        let action4 = ChimpionAlertAction(title: "更多选项", style: ChimpionAlertAction.default) { action in
            print("用户点击了更多选项按钮")
        }
        sheetController.addAction(action4)
        
        // 5. 添加取消按钮
        let cancelAction = ChimpionAlertAction(title: "取消", style: ChimpionAlertAction.cancel) { action in
            print("用户点击了取消按钮")
        }
        sheetController.addAction(cancelAction)
        
        // 设置自定义样式
        sheetController.setTitleStyle(font: UIFont.boldSystemFont(ofSize: 18), color: .systemPurple)
        sheetController.setMessageStyle(font: UIFont.systemFont(ofSize: 15), color: .gray)
        
        // 显示Sheet样式弹窗
        sheetController.show()
    }
}
