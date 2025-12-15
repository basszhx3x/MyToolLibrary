//
//  SearchBarControllerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

class SearchBarControllerTestViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let searchBarView = SearchBarView()
    private let resultLabel = UILabel()
    private let testButton = UIButton(type: .system)
    private var isCustomStyle = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "SearchBarView 测试"
        
        // 设置视图背景色
        view.backgroundColor = .white
        
        // 配置搜索栏视图
        configureSearchBarView()
        
        // 配置结果标签
        configureResultLabel()
        
        // 配置测试按钮
        configureTestButton()
        
        // 添加子视图并设置约束
        setupSubviewsAndConstraints()
    }
    
    // MARK: - Configuration
    
    private func configureSearchBarView() {
        // 设置搜索栏委托
        searchBarView.delegate = self
        
        // 设置占位符
        searchBarView.placeholder = "请输入搜索内容"
        
        // 显示清除按钮和取消按钮
        searchBarView.showsClearButton = true
        // 测试新增属性 - 默认样式
        searchBarView.searchBarHeight = 70.0
        searchBarView.searchBarBackgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        // searchBarView.searchTextFieldWidth = 120
        searchBarView.searchTextFieldBackgroundColor = UIColor.white
        searchBarView.searchTextFieldCornerRadius = 10

        searchBarView.searchTextFieldHeight = 50
        searchBarView.searchTextFieldMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        searchBarView.showsCancelButton = false
        searchBarView.showsBottomSeparator = true
        searchBarView.bottomSeparatorColor = .separator
        // 测试新功能：搜索图标配置
        searchBarView.searchIcon = UIImage(systemName: "magnifyingglass")
        searchBarView.searchIconTintColor = .systemGray
        searchBarView.searchIconPadding = 10
        
        // 测试新功能：文本框边缘间距配置
//        searchBarView.searchTextFieldMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // 测试点击输入框功能：点击搜索栏区域可以激活输入框
        // 测试取消按钮居中：观察取消按钮是否在搜索栏的垂直中心位置
        
        // 测试光标设置功能
        searchBarView.searchTextFieldCursorColor = .systemRed
        
        // 测试取消按钮样式设置
        searchBarView.cancelButtonTitle = "取消"
        searchBarView.cancelButtonTitleColor = .systemBlue
    }
    
    private func configureResultLabel() {
        resultLabel.text = "搜索结果将显示在这里"
        resultLabel.textAlignment = .center
        resultLabel.textColor = .gray
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.numberOfLines = 0
    }
    
    private func configureTestButton() {
        testButton.setTitle("切换样式", for: .normal)
        testButton.setTitleColor(.systemBlue, for: .normal)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        testButton.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Subviews and Constraints
    
    private func setupSubviewsAndConstraints() {
        // 添加搜索栏视图
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarView)
        
        // 添加结果标签
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)
        
        // 添加测试按钮
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 搜索栏约束
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 结果标签约束
            resultLabel.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 测试按钮约束
            testButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 30),
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 44),
            testButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // MARK: - UISearchBarDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 更新结果标签
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if currentText.isEmpty {
            resultLabel.text = "搜索结果将显示在这里"
            resultLabel.textColor = .gray
        } else {
            resultLabel.text = "搜索内容: \(currentText)"
            resultLabel.textColor = .black
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 结束编辑
        textField.resignFirstResponder()
        searchBarView.showsCancelButton = false
        // 更新结果标签
        if let searchText = textField.text, !searchText.isEmpty {
            resultLabel.text = "搜索完成: \(searchText)"
            resultLabel.textColor = .systemGreen
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBarView.showsCancelButton = true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        searchBarView.showsCancelButton = false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // 清空结果标签
        resultLabel.text = "搜索结果将显示在这里"
        resultLabel.textColor = .gray
        return true
    }
    
    // MARK: - Actions
    
    @objc private func testButtonTapped() {
        isCustomStyle.toggle()
        
        if isCustomStyle {
            // 切换到自定义样式
            searchBarView.searchBarHeight = 70.0
            searchBarView.searchBarBackgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0)
            
            searchBarView.searchTextFieldBackgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0)
            searchBarView.searchTextFieldCornerRadius = 20.0
            searchBarView.searchTextFieldBorderColor = UIColor.systemBlue
            searchBarView.searchTextFieldBorderWidth = 2.0
            searchBarView.searchTextFieldHeight = 46.0
            // searchBarView.searchTextFieldWidth = 120
            testButton.setTitle("恢复默认", for: .normal)
            
            // 设置文本颜色为白色以适配深色背景
            if let textField = searchBarView.searchTextField {
                textField.textColor = UIColor.white
                textField.attributedPlaceholder = NSAttributedString(
                    string: "请输入搜索内容",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
            }
            
            // 自定义光标样式
            searchBarView.searchTextFieldCursorColor = .systemYellow
            
            // 自定义取消按钮样式
            searchBarView.cancelButtonTitle = "关闭"
            searchBarView.cancelButtonTitleColor = .systemYellow
            
            // 自定义搜索图标配置
            searchBarView.searchIcon = UIImage(systemName: "search")
            searchBarView.searchIconTintColor = .systemYellow
            searchBarView.searchIconPadding = 15.0
            
            // 自定义文本框边缘间距配置
            searchBarView.searchViewEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else {
            // 恢复默认样式
            searchBarView.searchBarHeight = 70.0
            searchBarView.searchBarBackgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            
            searchBarView.searchTextFieldBackgroundColor = UIColor.white
            searchBarView.searchTextFieldCornerRadius = 12.0
            searchBarView.searchTextFieldBorderColor = UIColor.lightGray
            searchBarView.searchTextFieldBorderWidth = 1.0
            searchBarView.searchTextFieldHeight = 46
            // searchBarView.searchTextFieldWidth = 120
            testButton.setTitle("切换样式", for: .normal)
            
            // 恢复默认文本颜色
            if let textField = searchBarView.searchTextField {
                textField.textColor = UIColor.black
                textField.attributedPlaceholder = NSAttributedString(
                    string: "请输入搜索内容",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
            }
            
            // 恢复默认光标样式
            searchBarView.searchTextFieldCursorColor = .systemRed
            
            // 恢复默认取消按钮样式
            searchBarView.cancelButtonTitle = "取消"
            searchBarView.cancelButtonTitleColor = .systemBlue
            
            // 恢复默认搜索图标配置
            searchBarView.searchIcon = UIImage(systemName: "magnifyingglass")
            searchBarView.searchIconTintColor = .systemGray
            searchBarView.searchIconPadding = 10.0
            
            // 恢复默认文本框边缘间距配置
            searchBarView.searchViewEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        }
    }
}
