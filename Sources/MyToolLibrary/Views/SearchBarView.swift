//
//  SearchBarView.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit

// 自定义TextField，支持设置边缘间距
class ChimpionCustomSearchTextField: UITextField {
    var customEdgeInsets: UIEdgeInsets = .zero
    var leftViewPadding: CGFloat = 0
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftViewPadding
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // 计算左侧视图的总宽度（图标宽度 + 左侧和右侧间距）
        let leftViewTotalWidth = calculateLeftViewTotalWidth(forBounds: bounds)
        
        // 应用自定义边缘间距，并调整左侧内边距以避免与搜索图标重叠
        var adjustedEdgeInsets = customEdgeInsets
        adjustedEdgeInsets.left += leftViewTotalWidth
        
        return bounds.inset(by: adjustedEdgeInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // 计算左侧视图的总宽度（图标宽度 + 左侧和右侧间距）
        let leftViewTotalWidth = calculateLeftViewTotalWidth(forBounds: bounds)
        
        // 应用自定义边缘间距，并调整左侧内边距以避免与搜索图标重叠
        var adjustedEdgeInsets = customEdgeInsets
        adjustedEdgeInsets.left += leftViewTotalWidth
        
        return bounds.inset(by: adjustedEdgeInsets)
    }
    
    /// 计算左侧视图的总宽度（包括图标宽度 + leftViewPadding + 右侧间距）
    private func calculateLeftViewTotalWidth(forBounds bounds: CGRect) -> CGFloat {
        // 获取默认的左侧视图矩形
        let defaultLeftViewRect = super.leftViewRect(forBounds: bounds)
        
        // 计算左侧视图的总宽度（leftViewPadding + 图标宽度 + 右侧间距）
        let leftViewWidth = defaultLeftViewRect.width
        let rightPadding = 0.0 // 搜索图标和文本之间的默认间距
        
        return leftViewPadding + leftViewWidth + rightPadding
    }
}

public class SearchBarView: UIView {
    
    // MARK: - Properties
    
    // 搜索文本框
    private let internalSearchTextField = ChimpionCustomSearchTextField()
    
    // 取消按钮
    private let cancelButton = UIButton(type: .system)
    
    // 搜索栏高度
    public var searchBarHeight: CGFloat = 44.0 {
        didSet {
            updateSearchBarConstraints()
        }
    }
    
    // 搜索栏背景色
    public var searchBarBackgroundColor: UIColor = .white {
        didSet {
            backgroundColor = searchBarBackgroundColor
        }
    }
    
    // 搜索栏宽度
    public var searchBarWidth: CGFloat? {
        didSet {
            updateSearchBarConstraints()
        }
    }
    
    // 搜索图标
    public var searchIcon: UIImage? {
        didSet {
            updateSearchIcon()
        }
    }
    
    // 搜索图标颜色
    public var searchIconTintColor: UIColor = .lightGray {
        didSet {
            updateSearchIcon()
        }
    }
    
    // 搜索图标间距
    public var searchIconPadding: CGFloat = 8.0 {
        didSet {
            updateSearchIcon()
        }
    }
    
    // 搜索文本框边缘间距
    // 搜索文本框外部边距（相对于父视图）
    public var searchTextFieldMargins: UIEdgeInsets = .zero {
        didSet {
            isTextFieldMarginsCustomized = true
            updateSearchTextFieldConstraints()
        }
    }
    
    // 跟踪用户是否显式设置了searchTextFieldMargins
    private var isTextFieldMarginsCustomized = false
    
    // 搜索文本框内部边距
    public var searchViewEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            updateSearchViewEdgeInsets()
        }
    }
    
    // 搜索栏圆角
    public var searchBarCornerRadius: CGFloat = 0.0 {
        didSet {
            internalSearchTextField.layer.cornerRadius = searchBarCornerRadius
            internalSearchTextField.clipsToBounds = false
        }
    }
    
    // 搜索栏阴影颜色
    public var searchBarShadowColor: UIColor? {
        didSet {
            internalSearchTextField.layer.shadowColor = searchBarShadowColor?.cgColor
        }
    }
    
    // 搜索栏阴影偏移量
    public var searchBarShadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            internalSearchTextField.layer.shadowOffset = searchBarShadowOffset
        }
    }
    
    // 底部分割线
    public var showsBottomSeparator: Bool = false {
        didSet {
            updateBottomSeparatorVisibility()
        }
    }
    
    // 底部分割线颜色
    public var bottomSeparatorColor: UIColor = .lightGray {
        didSet {
            updateBottomSeparatorColor()
        }
    }
    
    // 底部分割线高度
    public var bottomSeparatorHeight: CGFloat = 1.0 {
        didSet {
            updateBottomSeparatorHeight()
        }
    }
    
    // 底部分割线视图
    private let bottomSeparatorView = UIView()
    
    // 搜索栏阴影透明度
    public var searchBarShadowOpacity: Float = 0.0 {
        didSet {
            internalSearchTextField.layer.shadowOpacity = searchBarShadowOpacity
        }
    }
    
    // 搜索栏阴影半径
    public var searchBarShadowRadius: CGFloat = 4.0 {
        didSet {
            internalSearchTextField.layer.shadowRadius = searchBarShadowRadius
        }
    }
    
    // 搜索框背景色
    public var searchTextFieldBackgroundColor: UIColor = .white {
        didSet {
            updateSearchTextFieldBackgroundColor()
        }
    }
    
    // 搜索框圆角
    public var searchTextFieldCornerRadius: CGFloat = 0.0 {
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
            internalSearchTextField.clearButtonMode = showsClearButton ? .whileEditing : .never
        }
    }
    
    // 是否显示取消按钮
    public var showsCancelButton: Bool = true {
        didSet {
            updateCancelButtonVisibility()
        }
    }
    
    // 取消按钮标题
    public var cancelButtonTitle: String = "取消" {
        didSet {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
        }
    }
    
    // 取消按钮标题颜色
    public var cancelButtonTitleColor: UIColor = .systemBlue {
        didSet {
            cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        }
    }
    
    // 搜索文本
    public var text: String? {
        get { return internalSearchTextField.text }
        set { internalSearchTextField.text = newValue }
    }
    
    // 占位符文本
    public var placeholder: String? {
        get { return internalSearchTextField.placeholder }
        set { internalSearchTextField.placeholder = newValue }
    }
    
    // 委托
    public weak var delegate: UITextFieldDelegate? {
        get { return internalSearchTextField.delegate }
        set { internalSearchTextField.delegate = newValue }
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
        
        // 配置搜索文本框
        configureSearchTextField()
        
        // 配置取消按钮
        configureCancelButton()
        
        // 配置底部分割线
        configureBottomSeparator()
        
        // 添加子视图
        addSubview(internalSearchTextField)
        addSubview(cancelButton)
        addSubview(bottomSeparatorView)
        
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
        updateBottomSeparatorVisibility()
        updateBottomSeparatorColor()
        updateBottomSeparatorHeight()
        
        // 添加点击手势以唤起输入框
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    // MARK: - Configuration
    
    private func configureSearchTextField() {
        internalSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        internalSearchTextField.placeholder = "搜索..."
        internalSearchTextField.backgroundColor = searchTextFieldBackgroundColor
        
        // 启用清除按钮
        internalSearchTextField.clearButtonMode = .whileEditing
        
        // 添加搜索图标
        updateSearchIcon()
    }
    
    private func updateSearchIcon() {
        // 创建搜索图标
        let icon = searchIcon ?? UIImage(systemName: "magnifyingglass")
        let iconView = UIImageView(image: icon)
        iconView.tintColor = searchIconTintColor
        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置图标大小
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        internalSearchTextField.leftView = iconView
        internalSearchTextField.leftViewMode = .always
        
        // 设置搜索图标左侧和右侧的间距
        internalSearchTextField.leftViewPadding = searchIconPadding
        
        // 触发布局更新
        internalSearchTextField.setNeedsLayout()
        internalSearchTextField.layoutIfNeeded()
    }
    
    private func updateSearchViewEdgeInsets() {
        // 搜索文本框内部边距
        internalSearchTextField.customEdgeInsets = searchViewEdgeInsets
        
        // 触发布局更新
        internalSearchTextField.setNeedsLayout()
        internalSearchTextField.layoutIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func updateSearchTextFieldConstraints() {
        // 移除与搜索文本框相关的所有位置约束
        self.constraints.forEach { constraint in
            if (constraint.firstItem as? UITextField == internalSearchTextField || constraint.secondItem as? UITextField == internalSearchTextField) {
                if [.top, .bottom, .leading, .trailing, .centerX, .centerY].contains(constraint.firstAttribute) {
                    constraint.isActive = false
                }
            }
        }
        
        // 根据用户是否显式设置了margins来决定使用哪种布局方式
        if isTextFieldMarginsCustomized {
            // 使用edges布局，设置top/bottom/leading/trailing约束
            let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
            searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
            let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
            searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
            
            // 降低垂直约束优先级，避免在高度为0时冲突
            let searchTextFieldTopConstraint = internalSearchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: searchTextFieldMargins.top)
            searchTextFieldTopConstraint.priority = .defaultHigh
            let searchTextFieldBottomConstraint = internalSearchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -searchTextFieldMargins.bottom)
            searchTextFieldBottomConstraint.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                searchTextFieldTopConstraint,
                searchTextFieldBottomConstraint,
                searchTextFieldLeadingConstraint,
                searchTextFieldTrailingConstraint
            ])
        } else {
            // 使用高度约束和centerY布局，不使用centerX以避免与leading/trailing约束冲突
            let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
            searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
            let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
            searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
            
            // 降低高度约束优先级，避免在高度为0时冲突
            let searchTextFieldHeightConstraint = internalSearchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight)
            searchTextFieldHeightConstraint.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                internalSearchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                searchTextFieldHeightConstraint,
                searchTextFieldLeadingConstraint,
                searchTextFieldTrailingConstraint
            ])
        }
    }
    
    private func updateSearchBarConstraints() {
        // 更新搜索栏自身的高度约束
        constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                removeConstraint(constraint)
            }
        }
        
        // 添加新的高度约束
        let heightConstraint = heightAnchor.constraint(equalToConstant: searchBarHeight)
        heightConstraint.priority = .defaultHigh // 降低高度约束优先级，避免与系统临时布局约束冲突
        heightConstraint.isActive = true
        
        // 更新搜索文本框的宽度和高度约束
        updateSearchTextFieldWidth()
    }
    
    // 获取搜索文本框
    public var searchTextField: UITextField? {
        return internalSearchTextField
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
            // 移除所有现有的高度约束
            textField.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    textField.removeConstraint(constraint)
                }
            }
            
            // 设置新的高度约束并降低优先级，避免在高度为0时冲突
            let heightConstraint = textField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight)
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
            
            textField.setNeedsLayout()
            textField.layoutIfNeeded()
        }
    }
    
    private func updateSearchTextFieldWidth() {
        // 移除所有与搜索文本框相关的宽度和水平位置约束
        constraints.forEach { constraint in
            if (constraint.firstItem as? UITextField == internalSearchTextField || 
                constraint.secondItem as? UITextField == internalSearchTextField) &&
               (constraint.firstAttribute == .width || constraint.firstAttribute == .leading || 
                constraint.firstAttribute == .trailing || constraint.firstAttribute == .centerX ||
                constraint.firstAttribute == .top || constraint.firstAttribute == .bottom ||
                constraint.firstAttribute == .centerY) {
                constraint.isActive = false
            }
        }
        
        // 如果设置了宽度，添加宽度约束
        if let width = searchBarWidth {
            // 根据用户是否显式设置了margins来决定使用哪种布局方式
            if isTextFieldMarginsCustomized {
                // 使用edges布局，设置top/bottom/leading/trailing约束
                let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
                searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
                let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
                searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
                
                // 降低垂直约束优先级，避免在高度为0时冲突
                let searchTextFieldTopConstraint = internalSearchTextField.topAnchor.constraint(equalTo: topAnchor, constant: searchTextFieldMargins.top)
                searchTextFieldTopConstraint.priority = .defaultHigh
                let searchTextFieldBottomConstraint = internalSearchTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -searchTextFieldMargins.bottom)
                searchTextFieldBottomConstraint.priority = .defaultHigh
                
                NSLayoutConstraint.activate([
                    searchTextFieldTopConstraint,
                    searchTextFieldBottomConstraint,
                    searchTextFieldLeadingConstraint,
                    searchTextFieldTrailingConstraint,
                    internalSearchTextField.widthAnchor.constraint(equalToConstant: width),
                    internalSearchTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                ])
            } else {
                // 使用高度约束和centerX/Y布局
                // 降低高度约束优先级，避免在高度为0时冲突
                let searchTextFieldHeightConstraint = internalSearchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight)
                searchTextFieldHeightConstraint.priority = .defaultHigh
                
                NSLayoutConstraint.activate([
                    internalSearchTextField.widthAnchor.constraint(equalToConstant: width),
                    internalSearchTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    internalSearchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    searchTextFieldHeightConstraint
                ])
            }
        } else {
            // 没有设置具体宽度时，让文本框自动适应搜索栏的宽度，左右保留一定边距
            // 根据用户是否显式设置了margins来决定使用哪种布局方式
            if isTextFieldMarginsCustomized {
                // 使用edges布局，设置top/bottom/leading/trailing约束
                let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
                searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
                let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
                searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
                NSLayoutConstraint.activate([
                    internalSearchTextField.topAnchor.constraint(equalTo: topAnchor, constant: searchTextFieldMargins.top),
                    internalSearchTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -searchTextFieldMargins.bottom),
                    searchTextFieldLeadingConstraint,
                    searchTextFieldTrailingConstraint
                ])
            } else {
                // 使用高度约束和centerY布局，不使用centerX以避免与leading/trailing约束冲突
                let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
                searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
                let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
                searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
                NSLayoutConstraint.activate([
                    internalSearchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    internalSearchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight),
                    searchTextFieldLeadingConstraint,
                    searchTextFieldTrailingConstraint
                ])
            }
        }
        
        // 触发布局更新
        internalSearchTextField.setNeedsLayout()
        internalSearchTextField.layoutIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func configureCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureBottomSeparator() {
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.backgroundColor = bottomSeparatorColor
        bottomSeparatorView.isHidden = !showsBottomSeparator
    }
    
    private func updateBottomSeparatorVisibility() {
        bottomSeparatorView.isHidden = !showsBottomSeparator
    }
    
    private func updateBottomSeparatorColor() {
        bottomSeparatorView.backgroundColor = bottomSeparatorColor
    }
    
    private func updateBottomSeparatorHeight() {
        // 移除现有的高度约束
        bottomSeparatorView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        
        // 添加新的高度约束
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: bottomSeparatorHeight).isActive = true
        
        // 触发布局更新
        bottomSeparatorView.setNeedsLayout()
        bottomSeparatorView.layoutIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        // 搜索栏内部文本框约束
        internalSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // 搜索栏高度约束
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: searchBarHeight)
        heightConstraint.priority = .defaultHigh // 降低高度约束优先级，避免与系统临时布局约束冲突
        heightConstraint.isActive = true
        
        // 取消按钮约束
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let cancelButtonWidthConstraint = cancelButton.widthAnchor.constraint(equalToConstant: 60)
        cancelButtonWidthConstraint.priority = .defaultHigh // 降低宽度约束优先级，避免在窄宽度下冲突
        let cancelButtonTrailingConstraint = cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        cancelButtonTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时与搜索文本框约束冲突
        NSLayoutConstraint.activate([
            cancelButtonTrailingConstraint,
            cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cancelButtonWidthConstraint
        ])
        
        // 底部分割线约束
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: bottomSeparatorHeight)
        ])
        
        // 根据用户是否显式设置了margins来决定使用哪种布局方式
        if isTextFieldMarginsCustomized {
            // 使用edges布局，设置top/bottom/leading/trailing约束
            let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
            searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
            let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
            searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
            
            // 降低垂直约束优先级，避免在高度为0时冲突
            let searchTextFieldTopConstraint = internalSearchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: searchTextFieldMargins.top)
            searchTextFieldTopConstraint.priority = .defaultHigh
            let searchTextFieldBottomConstraint = internalSearchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -searchTextFieldMargins.bottom)
            searchTextFieldBottomConstraint.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                searchTextFieldTopConstraint,
                searchTextFieldBottomConstraint,
                searchTextFieldLeadingConstraint,
                searchTextFieldTrailingConstraint
            ])
        } else {
            // 使用高度约束和centerY布局，不使用centerX以避免与leading/trailing约束冲突
            let searchTextFieldLeadingConstraint = internalSearchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: searchTextFieldMargins.left)
            searchTextFieldLeadingConstraint.priority = .defaultHigh // 降低leading约束优先级，避免在宽度为0时冲突
            let searchTextFieldTrailingConstraint = internalSearchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -searchTextFieldMargins.right)
            searchTextFieldTrailingConstraint.priority = .defaultHigh // 降低trailing约束优先级，避免在宽度为0时冲突
            
            // 降低高度约束优先级，避免在高度为0时冲突
            let searchTextFieldHeightConstraint = internalSearchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight)
            searchTextFieldHeightConstraint.priority = .defaultHigh
            
            NSLayoutConstraint.activate([
                internalSearchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                searchTextFieldHeightConstraint,
                searchTextFieldLeadingConstraint,
                searchTextFieldTrailingConstraint
            ])
        }
        
        // 初始化搜索文本框样式
        updateSearchTextFieldBackgroundColor()
        updateSearchTextFieldCornerRadius()
        updateSearchTextFieldBorderColor()
        updateSearchTextFieldBorderWidth()
        updateSearchTextFieldCursorColor()
        updateSearchTextFieldHeight()
        updateSearchTextFieldWidth()
        updateSearchViewEdgeInsets()
    }
    
    // MARK: - Methods
    
    private func updateCancelButtonVisibility() {
        cancelButton.isHidden = !showsCancelButton
    }
    
    @objc private func cancelButtonTapped() {
        // 清空搜索文本
        internalSearchTextField.text = ""
        
        // 结束编辑
        internalSearchTextField.resignFirstResponder()
        
        // 通知委托
        delegate?.textFieldShouldReturn?(internalSearchTextField)
    }
    
    // 聚焦搜索文本框
    public override func becomeFirstResponder() -> Bool {
        return internalSearchTextField.becomeFirstResponder()
    }
    
    // 取消聚焦搜索文本框
    public override func resignFirstResponder() -> Bool {
        return internalSearchTextField.resignFirstResponder()
    }
    
    // MARK: - Gesture Handling
    
    @objc private func handleTap() {
        // 点击组件时唤起输入框
        becomeFirstResponder()
    }
    
    // 确保点击事件能正确传递给searchTextField
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 先检查是否点击了取消按钮
        let cancelButtonView = cancelButton.hitTest(convert(point, to: cancelButton), with: event)
        if cancelButtonView != nil {
            return cancelButtonView
        }
        
        // 如果点击了组件的其他部分，传递给searchTextField
        return internalSearchTextField.hitTest(convert(point, to: internalSearchTextField), with: event)
    }
}
