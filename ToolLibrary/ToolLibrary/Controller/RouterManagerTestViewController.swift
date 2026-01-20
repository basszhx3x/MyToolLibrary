//
//  RouterManagerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2026/1/16.
//

import UIKit
import ChimpionTools

// 用于测试的目标视图控制器
final class RouterDestinationViewController: UIViewController {
    private let infoLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private var receivedParameters: [String: Any]?
    
    init(parameters: [String: Any]) {
        self.receivedParameters = parameters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "路由目标页面"
        view.backgroundColor = .white
        
        configureInfoLabel()
        configureBackButton()
        setupSubviewsAndConstraints()
    }
    
    private func configureInfoLabel() {
        var infoText = "接收到的参数："
        
        if let parameters = receivedParameters {
            if parameters.isEmpty {
                infoText += "无"
            } else {
                for (key, value) in parameters {
                    infoText += "\n\(key): \(value)"
                }
            }
        } else {
            infoText += "无"
        }
        
        infoLabel.text = infoText
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.numberOfLines = 0
    }
    
    private func configureBackButton() {
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviewsAndConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoLabel)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            // 信息标签约束
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 返回按钮约束
            backButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// RouterManager测试页面
class RouterManagerTestViewController: UIViewController {
    
    // MARK: - Properties
    
    private let statusLabel = UILabel()
    private let testButton1 = UIButton(type: .system)
    private let testButton2 = UIButton(type: .system)
    private let testButton3 = UIButton(type: .system)
    private let testButton4 = UIButton(type: .system)
    private let customURIField = UITextField()
    private let customURIButton = UIButton(type: .system)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "RouterManager 测试"
        
        // 设置视图背景色
        view.backgroundColor = .white
        
        // 注册路由
        registerTestRoutes()
        
        // 配置状态标签
        configureStatusLabel()
        
        // 配置测试按钮
        configureTestButtons()
        
        // 配置自定义URI输入框和按钮
        configureCustomURIField()
        
        // 添加子视图并设置约束
        setupSubviewsAndConstraints()
    }
    
    // MARK: - Router Registration
    
    private func registerTestRoutes() {
        // 清理之前的路由注册
        RouterManager.shared.clearRoutes()
        
        // 注册首页路由
        RouterManager.shared.register(path: "home") { (vc, params) in
            let destinationVC = RouterDestinationViewController(parameters: params)
            vc.navigationController?.pushViewController(destinationVC, animated: true)
            return true
        }
        
        // 注册带参数的详情页路由
        RouterManager.shared.register(path: "detail/:id") { (vc, params) in
            let destinationVC = RouterDestinationViewController(parameters: params)
            vc.navigationController?.pushViewController(destinationVC, animated: true)
            return true
        }
        
        // 注册产品页面路由
        RouterManager.shared.register(path: "product/:productId/info") { (vc, params) in
            let destinationVC = RouterDestinationViewController(parameters: params)
            vc.navigationController?.pushViewController(destinationVC, animated: true)
            return true
        }
        
        // 注册模态展示的设置页面路由
        RouterManager.shared.register(path: "settings") { (vc, params) in
            let destinationVC = RouterDestinationViewController(parameters: params)
            let navVC = UINavigationController(rootViewController: destinationVC)
            navVC.modalPresentationStyle = .formSheet
            vc.present(navVC, animated: true, completion: nil)
            return true
        }
        
        // 设置默认路由
        RouterManager.shared.registerDefault { (vc, params) in
            let alert = UIAlertController(title: "路由错误", message: "未找到匹配的路由", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            return true
        }
        
        // 使用类型安全API注册路由
        RouterManager.shared.register(path: "profile/:userId") { params -> RouterDestinationViewController? in
            return RouterDestinationViewController(parameters: params)
        }
    }
    
    // MARK: - Configuration
    
    private func configureStatusLabel() {
        statusLabel.text = "已注册路由：home、detail/:id、product/:productId/info、settings、profile/:userId"
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemBlue
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.numberOfLines = 0
    }
    
    private func configureTestButtons() {
        // 测试按钮1：首页路由
        testButton1.setTitle("测试首页路由", for: .normal)
        testButton1.setTitleColor(.systemBlue, for: .normal)
        testButton1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        testButton1.addTarget(self, action: #selector(testButton1Tapped), for: .touchUpInside)
        
        // 测试按钮2：带参数的详情页路由
        testButton2.setTitle("测试详情页路由", for: .normal)
        testButton2.setTitleColor(.systemBlue, for: .normal)
        testButton2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        testButton2.addTarget(self, action: #selector(testButton2Tapped), for: .touchUpInside)
        
        // 测试按钮3：复杂参数路由
        testButton3.setTitle("测试复杂参数路由", for: .normal)
        testButton3.setTitleColor(.systemBlue, for: .normal)
        testButton3.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        testButton3.addTarget(self, action: #selector(testButton3Tapped), for: .touchUpInside)
        
        // 测试按钮4：模态路由
        testButton4.setTitle("测试模态路由", for: .normal)
        testButton4.setTitleColor(.systemBlue, for: .normal)
        testButton4.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        testButton4.addTarget(self, action: #selector(testButton4Tapped), for: .touchUpInside)
    }
    
    private func configureCustomURIField() {
        customURIField.placeholder = "输入自定义URI (如: myapp://profile/123?name=test)"
        customURIField.borderStyle = .roundedRect
        customURIField.font = UIFont.systemFont(ofSize: 14)
        customURIField.clearButtonMode = .whileEditing
        customURIField.returnKeyType = .done
        customURIField.delegate = self
        
        customURIButton.setTitle("执行自定义URI", for: .normal)
        customURIButton.setTitleColor(.systemBlue, for: .normal)
        customURIButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        customURIButton.addTarget(self, action: #selector(customURIButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Subviews and Constraints
    
    private func setupSubviewsAndConstraints() {
        // 添加所有子视图
        let subviews = [statusLabel, testButton1, testButton2, testButton3, testButton4, customURIField, customURIButton]
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 状态标签约束
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 测试按钮1约束
            testButton1.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            testButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testButton1.heightAnchor.constraint(equalToConstant: 50),
            
            // 测试按钮2约束
            testButton2.topAnchor.constraint(equalTo: testButton1.bottomAnchor, constant: 20),
            testButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testButton2.heightAnchor.constraint(equalToConstant: 50),
            
            // 测试按钮3约束
            testButton3.topAnchor.constraint(equalTo: testButton2.bottomAnchor, constant: 20),
            testButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testButton3.heightAnchor.constraint(equalToConstant: 50),
            
            // 测试按钮4约束
            testButton4.topAnchor.constraint(equalTo: testButton3.bottomAnchor, constant: 20),
            testButton4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testButton4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testButton4.heightAnchor.constraint(equalToConstant: 50),
            
            // 自定义URI输入框约束
            customURIField.topAnchor.constraint(equalTo: testButton4.bottomAnchor, constant: 40),
            customURIField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customURIField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customURIField.heightAnchor.constraint(equalToConstant: 40),
            
            // 自定义URI按钮约束
            customURIButton.topAnchor.constraint(equalTo: customURIField.bottomAnchor, constant: 20),
            customURIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customURIButton.heightAnchor.constraint(equalToConstant: 44),
            customURIButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func testButton1Tapped() {
        // 测试首页路由
        let success = RouterManager.shared.route(to: "myapp://home", from: self)
        updateStatus(success ? "首页路由执行成功" : "首页路由执行失败")
    }
    
    @objc private func testButton2Tapped() {
        // 测试带参数的详情页路由
        let success = RouterManager.shared.route(to: "myapp://detail/123/?name=测试产品&price=99.9", from: self)
        updateStatus(success ? "详情页路由执行成功" : "详情页路由执行失败")
    }
    
    @objc private func testButton3Tapped() {
        // 测试复杂参数路由
        let success = RouterManager.shared.route(to: "myapp://product/456/info?category=electronics&brand=Apple", from: self)
        updateStatus(success ? "复杂参数路由执行成功" : "复杂参数路由执行失败")
    }
    
    @objc private func testButton4Tapped() {
        // 测试模态路由
        let success = RouterManager.shared.route(to: "myapp://settings", from: self)
        updateStatus(success ? "模态路由执行成功" : "模态路由执行失败")
    }
    
    @objc private func customURIButtonTapped() {
        // 测试自定义URI
        guard let uri = customURIField.text, !uri.isEmpty else {
            updateStatus("请输入URI")
            return
        }
        
        let success = RouterManager.shared.route(to: uri, from: self)
        updateStatus(success ? "自定义URI执行成功" : "自定义URI执行失败")
    }
    

    
    private func updateStatus(_ message: String) {
        statusLabel.text = message
        statusLabel.textColor = message.contains("成功") ? .systemGreen : .systemRed
        
        // 3秒后恢复原始状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.statusLabel.text = "已注册路由：home、detail/:id、product/:productId/info、settings、profile/:userId"
            self.statusLabel.textColor = .systemBlue
        }
    }
}

// MARK: - UITextFieldDelegate

extension RouterManagerTestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == customURIField {
            customURIButtonTapped()
        }
        return true
    }
}
