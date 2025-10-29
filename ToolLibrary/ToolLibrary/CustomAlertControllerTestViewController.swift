//
//  CustomAlertControllerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

// ChimpionCustomAlertController 测试视图控制器
class CustomAlertControllerTestViewController: UIViewController {
    
    // 用于演示的存储变量
    private var alertController: ChimpionCustomAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色
        view.backgroundColor = .white
        
        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "ChimpionCustomAlertController 测试"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 创建测试按钮
        createTestButtons()
        
        // 设置标题约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // 创建测试按钮
    private func createTestButtons() {
        // 基本测试按钮
        let basicTestButton = UIButton(type: .system)
        basicTestButton.setTitle("基本弹窗测试", for: .normal)
        basicTestButton.backgroundColor = .systemBlue
        basicTestButton.setTitleColor(.white, for: .normal)
        basicTestButton.layer.cornerRadius = 8
        basicTestButton.translatesAutoresizingMaskIntoConstraints = false
        basicTestButton.addTarget(self, action: #selector(showBasicAlert), for: .touchUpInside)
        
        // 底部关闭按钮测试
        let closeButtonTestButton = UIButton(type: .system)
        closeButtonTestButton.setTitle("带关闭按钮弹窗", for: .normal)
        closeButtonTestButton.backgroundColor = .systemGreen
        closeButtonTestButton.setTitleColor(.white, for: .normal)
        closeButtonTestButton.layer.cornerRadius = 8
        closeButtonTestButton.translatesAutoresizingMaskIntoConstraints = false
        closeButtonTestButton.addTarget(self, action: #selector(showAlertWithCloseButton), for: .touchUpInside)
        
        // 自定义样式测试
        let customStyleTestButton = UIButton(type: .system)
        customStyleTestButton.setTitle("自定义样式弹窗", for: .normal)
        customStyleTestButton.backgroundColor = .systemOrange
        customStyleTestButton.setTitleColor(.white, for: .normal)
        customStyleTestButton.layer.cornerRadius = 8
        customStyleTestButton.translatesAutoresizingMaskIntoConstraints = false
        customStyleTestButton.addTarget(self, action: #selector(showCustomStyleAlert), for: .touchUpInside)
        
        // 自定义关闭按钮样式
        let customCloseButtonTestButton = UIButton(type: .system)
        customCloseButtonTestButton.setTitle("自定义关闭按钮样式", for: .normal)
        customCloseButtonTestButton.backgroundColor = .systemPurple
        customCloseButtonTestButton.setTitleColor(.white, for: .normal)
        customCloseButtonTestButton.layer.cornerRadius = 8
        customCloseButtonTestButton.translatesAutoresizingMaskIntoConstraints = false
        customCloseButtonTestButton.addTarget(self, action: #selector(showCustomCloseButtonAlert), for: .touchUpInside)
        
        // 禁用点击外部关闭测试
        let disableTapOutsideTestButton = UIButton(type: .system)
        disableTapOutsideTestButton.setTitle("禁用点击外部关闭", for: .normal)
        disableTapOutsideTestButton.backgroundColor = .systemRed
        disableTapOutsideTestButton.setTitleColor(.white, for: .normal)
        disableTapOutsideTestButton.layer.cornerRadius = 8
        disableTapOutsideTestButton.translatesAutoresizingMaskIntoConstraints = false
        disableTapOutsideTestButton.addTarget(self, action: #selector(showAlertWithoutTapOutside), for: .touchUpInside)
        
        // 添加按钮到视图
        [basicTestButton, closeButtonTestButton, customStyleTestButton, customCloseButtonTestButton, disableTapOutsideTestButton].forEach { view.addSubview($0) }
        
        // 创建栈视图来排列按钮
        let stackView = UIStackView(arrangedSubviews: [basicTestButton, closeButtonTestButton, customStyleTestButton, customCloseButtonTestButton, disableTapOutsideTestButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 设置栈视图约束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    // 创建基本内容视图的辅助方法
    private func createBasicContentView() -> UIView {
        let customView = UIView()
        customView.backgroundColor = .white
        
        // 添加标题标签
        let titleLabel = UILabel()
        titleLabel.text = "弹窗标题"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加消息标签
        let messageLabel = UILabel()
        messageLabel.text = "这是一个使用ChimpionCustomAlertController显示的自定义弹窗内容，可以包含任意UI元素。"
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加内部按钮
        let actionButton = UIButton(type: .system)
        actionButton.setTitle("确定", for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 8
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        // 添加子视图
        [titleLabel, messageLabel, actionButton].forEach { customView.addSubview($0) }
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 自定义视图尺寸
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 220),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
            
            // 消息约束
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
            
            // 按钮约束
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -24)
        ])
        
        return customView
    }
    
    // 基本弹窗测试 - 使用默认配置
    @objc private func showBasicAlert() {
        let contentView = createBasicContentView()
        
        // 使用默认配置
        let config = ChimpionAlertConfig()
        
        // 显示弹窗
        alertController = self.showChimpionAlert(contentView: contentView, config: config)
        
        print("显示基本弹窗，使用默认配置")
    }
    
    // 带底部关闭按钮的弹窗测试
    @objc private func showAlertWithCloseButton() {
        let contentView = createBasicContentView()
        
        // 配置显示底部关闭按钮
        let config = ChimpionAlertConfig(
            cornerRadius: ChimpionAlertConfig.default.cornerRadius,  // 使用默认圆角值
            allowTapOutsideToDismiss: false,                         // 禁用点击外部关闭
            showCloseButton: true                                    // 显示底部关闭按钮
        )
        
        // 显示弹窗
        alertController = self.showChimpionAlert(contentView: contentView, config: config)
        
        print("显示带底部关闭按钮的弹窗")
    }
    
    // 自定义样式弹窗测试
    @objc private func showCustomStyleAlert() {
        let contentView = createBasicContentView()
        
        // 自定义弹窗样式
        let config = ChimpionAlertConfig(
            cornerRadius: 24,                // 更大的圆角
            backgroundColor: .systemGray5,   // 灰色背景
            backgroundOpacity: 0.6,          // 半透明背景遮罩
            allowTapOutsideToDismiss: true,  // 允许点击外部关闭
            minHeight: 250,                  // 最小高度250
            horizontalPadding: 30,           // 左右边距30
            maxWidth: 340                    // 最大宽度340
        )
        
        // 显示弹窗
        alertController = self.showChimpionAlert(contentView: contentView, config: config)
        
        print("显示自定义样式弹窗")
    }
    
    // 自定义关闭按钮样式测试
    @objc private func showCustomCloseButtonAlert() {
        let contentView = createBasicContentView()
        
        // 自定义关闭按钮样式
        let config = ChimpionAlertConfig(
            cornerRadius: 16,                           // 较大圆角
            showCloseButton: true,                      // 显示底部关闭按钮
            closeButtonText: "确认并关闭",               // 自定义按钮文本
            closeButtonTextColor: .white,               // 白色文字
            closeButtonBackgroundColor: .systemGreen    // 绿色背景
        )
        
        // 显示弹窗
        alertController = self.showChimpionAlert(contentView: contentView, config: config)
        
        print("显示带自定义关闭按钮的弹窗")
    }
    
    // 禁用点击外部关闭测试
    @objc private func showAlertWithoutTapOutside() {
        let contentView = createBasicContentView()
        
        // 禁用点击外部关闭，必须使用内部按钮关闭
        let config = ChimpionAlertConfig(
            cornerRadius: ChimpionAlertConfig.default.cornerRadius,
            backgroundOpacity: 0.8,// 使用默认圆角值
            allowTapOutsideToDismiss: false                        // 禁用点击外部关闭
                                              // 更不透明的背景遮罩
        )
        
        // 显示弹窗
        alertController = self.showChimpionAlert(contentView: contentView, config: config)
        
        print("显示禁用点击外部关闭的弹窗")
    }
    
    // 关闭弹窗
    @objc private func dismissAlert() {
        if let alertController = alertController {
            alertController.dismissAlert()
            self.alertController = nil
            print("弹窗已关闭")
        }
    }
}
