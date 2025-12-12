//
//  SearchBarView.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit

public class SearchBarView: UIView {
    
    // MARK: - Properties
    
    // 搜索栏
    private let searchBar = UISearchBar()
    
    // 取消按钮
    private let cancelButton = UIButton(type: .system)
    
    // 搜索栏高度
    public var searchBarHeight: CGFloat = 44.0 {
        didSet {
            updateSearchBarConstraints()
        }
    }
    
    // 搜索栏宽度
    public var searchBarWidth: CGFloat? {
        didSet {
            updateSearchBarConstraints()
        }
    }
    
    // 搜索栏背景色
    public var searchBarBackgroundColor: UIColor = .white {
        didSet {
            searchBar.backgroundColor = searchBarBackgroundColor
        }
    }
    
    // 搜索框背景色
    public var searchTextFieldBackgroundColor: UIColor = .white {
        didSet {
            updateSearchTextFieldBackgroundColor()
        }
    }
    
    // 搜索框圆角
    public var searchTextFieldCornerRadius: CGFloat = 8.0 {
        didSet {
            updateSearchTextFieldCornerRadius()
        }
    }
    
    // 搜索框边框颜色
    public var searchTextFieldBorderColor: UIColor? {
        didSet {
            updateSearchTextFieldBorderColor()
        }
    }
    
    // 搜索框边框宽度
    public var searchTextFieldBorderWidth: CGFloat = 0.0 {
        didSet {
            updateSearchTextFieldBorderWidth()
        }
    }
    
    // 搜索框光标颜色
    public var searchTextFieldCursorColor: UIColor = .systemBlue {
        didSet {
            updateSearchTextFieldCursorColor()
        }
    }
    
    // 搜索框高度
    public var searchTextFieldHeight: CGFloat = 32.0 {
        didSet {
            updateSearchTextFieldHeight()
        }
    }
    
    // 搜索框宽度
    public var searchTextFieldWidth: CGFloat? {
        didSet {
            updateSearchTextFieldWidth()
        }
    }
    
    // 是否显示清除按钮
    public var showsClearButton: Bool = true {
        didSet {
            searchBar.showsCancelButton = showsClearButton
        }
    }
    
    // 是否显示取消按钮
    public var showsCancelButton: Bool = true {
        didSet {
            updateCancelButtonVisibility()
        }
    }
    
    // 搜索文本
    public var text: String? {
        get { return searchBar.text }
        set { searchBar.text = newValue }
    }
    
    // 占位符文本
    public var placeholder: String? {
        get { return searchBar.placeholder }
        set { searchBar.placeholder = newValue }
    }
    
    // 委托
    public weak var delegate: UISearchBarDelegate? {
        get { return searchBar.delegate }
        set { searchBar.delegate = newValue }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // 设置背景色
        backgroundColor = .white
        
        // 配置搜索栏
        configureSearchBar()
        
        // 配置取消按钮
        configureCancelButton()
        
        // 添加子视图
        addSubview(searchBar)
        addSubview(cancelButton)
        
        // 设置约束
        setupConstraints()
        
        // 初始更新
        updateCancelButtonVisibility()
        updateSearchTextFieldBackgroundColor()
        updateSearchTextFieldCornerRadius()
        updateSearchTextFieldBorderColor()
        updateSearchTextFieldBorderWidth()
        updateSearchTextFieldCursorColor()
        updateSearchTextFieldHeight()
        updateSearchTextFieldWidth()
        
        // 添加点击手势以唤起输入框
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    // MARK: - Configuration
    
    private func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.placeholder = "搜索..."
        searchBar.backgroundColor = searchBarBackgroundColor
    }
    
    private func updateSearchBarConstraints() {
        // 移除旧的高度约束
        searchBar.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                searchBar.removeConstraint(constraint)
            }
        }
        
        // 添加新的高度约束
        searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
        
        // 更新宽度约束
        if let width = searchBarWidth {
            searchBar.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            // 移除旧的宽度约束
            searchBar.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    searchBar.removeConstraint(constraint)
                }
            }
        }
    }
    
    // 获取搜索文本框，兼容iOS 13.0+系统
    public var searchTextField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchBar.searchTextField
        } else {
            return searchBar.value(forKey: "searchField") as? UITextField
        }
    }
    
    private func updateSearchTextFieldBackgroundColor() {
        searchTextField?.backgroundColor = searchTextFieldBackgroundColor
    }
    
    private func updateSearchTextFieldCornerRadius() {
        if let textField = searchTextField {
            textField.layer.cornerRadius = searchTextFieldCornerRadius
            textField.clipsToBounds = true
        }
    }
    
    private func updateSearchTextFieldBorderColor() {
        searchTextField?.layer.borderColor = searchTextFieldBorderColor?.cgColor
    }
    
    private func updateSearchTextFieldBorderWidth() {
        searchTextField?.layer.borderWidth = searchTextFieldBorderWidth
    }
    
    private func updateSearchTextFieldCursorColor() {
        searchTextField?.tintColor = searchTextFieldCursorColor
    }
    
    private func updateSearchTextFieldHeight() {
        if let textField = searchTextField {
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            // 移除所有现有的高度和垂直位置约束
            textField.constraints.forEach { constraint in
                if constraint.firstAttribute == .height || constraint.firstAttribute == .top || constraint.firstAttribute == .bottom || constraint.firstAttribute == .centerY {
                    textField.removeConstraint(constraint)
                }
            }
            
            // 设置文本框高度
            textField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight).isActive = true
            
            // 设置文本框垂直居中
            textField.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
            
            // 更新文本框的垂直对齐
            textField.contentVerticalAlignment = .center
        }
    }
    
    private func updateSearchTextFieldWidth() {
        if let textField = searchTextField {
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            // 移除所有现有的宽度和水平位置约束
            textField.constraints.forEach { constraint in
                if constraint.firstAttribute == .width || constraint.firstAttribute == .leading || constraint.firstAttribute == .trailing || constraint.firstAttribute == .centerX {
                    textField.removeConstraint(constraint)
                }
            }
            
            // 如果设置了宽度，添加宽度约束并使其居中
            if let width = searchTextFieldWidth {
                textField.widthAnchor.constraint(equalToConstant: width).isActive = true
                textField.centerXAnchor.constraint(equalTo: searchBar.centerXAnchor).isActive = true
            } else {
                // 没有设置具体宽度时，让文本框自动适应搜索栏的宽度，左右保留一定边距
                textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 8).isActive = true
                textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -8).isActive = true
            }
        }
    }
    
    private func configureCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 搜索栏约束
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8),
            
            // 取消按钮约束 - 设置y轴居中（相对于searchBar居中）
            cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
        
        // 添加搜索栏高度约束
        searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
        
        // 如果设置了搜索栏宽度，添加宽度约束
        if let width = searchBarWidth {
            searchBar.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // 初始化搜索文本框样式
        updateSearchTextFieldBackgroundColor()
        updateSearchTextFieldCornerRadius()
        updateSearchTextFieldBorderColor()
        updateSearchTextFieldBorderWidth()
        updateSearchTextFieldCursorColor()
        updateSearchTextFieldHeight()
        updateSearchTextFieldWidth()
    }
    
    // MARK: - Methods
    
    private func updateCancelButtonVisibility() {
        cancelButton.isHidden = !showsCancelButton
    }
    
    @objc private func cancelButtonTapped() {
        // 清空搜索文本
        searchBar.text = ""
        
        // 结束编辑
        searchBar.resignFirstResponder()
        
        // 通知委托
        delegate?.searchBarCancelButtonClicked?(searchBar)
    }
    
    // 聚焦搜索栏
    public override func becomeFirstResponder() -> Bool {
        return searchBar.becomeFirstResponder()
    }
    
    // 取消聚焦搜索栏
    public override func resignFirstResponder() -> Bool {
        return searchBar.resignFirstResponder()
    }
    
    // MARK: - Gesture Handling
    
    @objc private func handleTap() {
        // 点击组件时唤起输入框
        becomeFirstResponder()
    }
    
    // 确保点击事件能正确传递给UISearchBar
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 先检查是否点击了取消按钮
        let cancelButtonView = cancelButton.hitTest(convert(point, to: cancelButton), with: event)
        if cancelButtonView != nil {
            return cancelButtonView
        }
        
        // 如果点击了组件的其他部分，传递给UISearchBar
        return searchBar.hitTest(convert(point, to: searchBar), with: event)
    }
}
