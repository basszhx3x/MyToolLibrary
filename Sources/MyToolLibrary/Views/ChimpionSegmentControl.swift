//
//  ChimpionSegmentControl.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit

/// 底部指示条类型枚举
@available(iOS 15.0, *)
public enum IndicatorStyle {
    /// 指示器与字体宽度相同
    case fitToText
    /// 指示器充满整个选项宽度
    case fullWidth
}

/// 分段控制器配置结构体
@available(iOS 15.0, *)
public struct SegmentConfig {
    /// 选中状态文字颜色
    public var selectedTextColor: UIColor
    /// 未选中状态文字颜色
    public var unselectedTextColor: UIColor
    /// 选中状态背景颜色
    public var selectedBackgroundColor: UIColor
    /// 未选中状态背景颜色
    public var unselectedBackgroundColor: UIColor
    /// 字体样式
    public var font: UIFont
    /// 底部指示条样式
    public var indicatorStyle: IndicatorStyle
    /// 底部指示条颜色
    public var indicatorColor: UIColor
    /// 底部指示条高度
    public var indicatorHeight: CGFloat
    /// 选项间距
    public var itemSpacing: CGFloat
    /// 内边距
    public var contentInsets: UIEdgeInsets
    /// 是否显示分割线
    public var showDivider: Bool
    /// 分割线颜色
    public var dividerColor: UIColor
    /// 分割线宽度
    public var dividerWidth: CGFloat
    /// 分割线高度占比（相对于按钮高度）
    public var dividerHeightRatio: CGFloat
    
    /// 配置结构体的默认初始化器
    public init(
        selectedTextColor: UIColor = .systemBlue,
        unselectedTextColor: UIColor = .systemGray,
        selectedBackgroundColor: UIColor = .clear,
        unselectedBackgroundColor: UIColor = .clear,
        font: UIFont = .systemFont(ofSize: 16),
        indicatorStyle: IndicatorStyle = .fullWidth,
        indicatorColor: UIColor = .systemBlue,
        indicatorHeight: CGFloat = 3,
        itemSpacing: CGFloat = 0,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        showDivider: Bool = false,
        dividerColor: UIColor = .systemGray3,
        dividerWidth: CGFloat = 1,
        dividerHeightRatio: CGFloat = 0.7
    ) {
        self.selectedTextColor = selectedTextColor
        self.unselectedTextColor = unselectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.unselectedBackgroundColor = unselectedBackgroundColor
        self.font = font
        self.indicatorStyle = indicatorStyle
        self.indicatorColor = indicatorColor
        self.indicatorHeight = indicatorHeight
        self.itemSpacing = itemSpacing
        self.contentInsets = contentInsets
        self.showDivider = showDivider
        self.dividerColor = dividerColor
        self.dividerWidth = dividerWidth
        self.dividerHeightRatio = dividerHeightRatio
    }
}

/// 自定义分段控制器组件
/// - 注意: 仅支持iOS 15.0及以上版本
@available(iOS 15.0, *)
public class ChimpionSegmentControl: UIView {
    
    // MARK: - 配置属性
    
    /// 分段控制器配置
    public var config: SegmentConfig {
        didSet {
            updateUI()
        }
    }
    
    /// 选项标题数组
    public var titles: [String] {
        didSet {
            setupSegments()
        }
    }
    
    /// 当前选中的索引
    public var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex >= 0 && selectedIndex < titles.count else {
                selectedIndex = oldValue
                return
            }
            updateSelectedState()
            animateIndicator()
            selectionCallback?(selectedIndex)
        }
    }
    
    /// 选中回调
    public var selectionCallback: ((Int) -> Void)?
    
    // MARK: - 私有属性
    
    /// 存储所有分段按钮
    private var segmentButtons: [UIButton] = []
    /// 存储所有分割线视图
    private var dividerViews: [UIView] = []
    
    /// 底部指示条
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = config.indicatorColor
        view.layer.cornerRadius = config.indicatorHeight / 2
        return view
    }()
    
    // MARK: - 初始化
    
    /// 使用配置和标题数组初始化分段控制器
    /// - Parameters:
    ///   - config: 分段控制器配置
    ///   - titles: 选项标题数组
    public init(config: SegmentConfig = SegmentConfig(), titles: [String] = []) {
        self.config = config
        self.titles = titles
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.config = SegmentConfig()
        self.titles = []
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI 设置
    
    private func setupUI() {
        backgroundColor = .clear
        setupSegments()
        addSubview(indicatorView)
    }
    
    private func setupSegments() {
        // 移除所有现有按钮
        segmentButtons.forEach { $0.removeFromSuperview() }
        segmentButtons.removeAll()
        
        // 移除所有现有分割线
        dividerViews.forEach { $0.removeFromSuperview() }
        dividerViews.removeAll()
        
        // 创建新按钮
        for (index, title) in titles.enumerated() {
            let button = createSegmentButton(title: title, index: index)
            addSubview(button)
            segmentButtons.append(button)
            
            // 创建分割线（最后一个item不创建分割线）
            if config.showDivider && index < titles.count - 1 {
                let dividerView = createDividerView()
                addSubview(dividerView)
                dividerViews.append(dividerView)
            }
        }
        
        // 更新选中状态和指示器位置
        updateSelectedState()
        updateIndicatorFrame(animated: false)
    }
    
    private func createSegmentButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(config.unselectedTextColor, for: .normal)
        button.setTitleColor(config.selectedTextColor, for: .selected)
        button.titleLabel?.font = config.font
        button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
        button.tag = index
        
        return button
    }
    
    // MARK: - 更新UI
    
    private func updateUI() {
        // 更新按钮样式
        for button in segmentButtons {
            button.setTitleColor(config.unselectedTextColor, for: .normal)
            button.setTitleColor(config.selectedTextColor, for: .selected)
            button.titleLabel?.font = config.font
        }
        
        // 更新分割线样式
        for dividerView in dividerViews {
            dividerView.backgroundColor = config.dividerColor
        }
        
        // 更新指示器样式
        indicatorView.backgroundColor = config.indicatorColor
        indicatorView.layer.cornerRadius = config.indicatorHeight / 2
        
        // 重新布局
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func updateSelectedState() {
        for (index, button) in segmentButtons.enumerated() {
            button.isSelected = (index == selectedIndex)
            button.backgroundColor = index == selectedIndex ? config.selectedBackgroundColor : config.unselectedBackgroundColor
        }
    }
    
    private func updateIndicatorFrame(animated: Bool = true) {
        guard selectedIndex < segmentButtons.count else { return }
        
        let selectedButton = segmentButtons[selectedIndex]
        var indicatorFrame: CGRect
        
        switch config.indicatorStyle {
        case .fitToText:
            // 计算文本宽度
            guard let title = selectedButton.title(for: .selected) else {
                indicatorFrame = CGRect(x: selectedButton.frame.midX - selectedButton.frame.width / 4,
                                       y: bounds.height - config.indicatorHeight,
                                       width: selectedButton.frame.width / 2,
                                       height: config.indicatorHeight)
                break
            }
            
            let textWidth = title.size(withAttributes: [.font: config.font]).width
            indicatorFrame = CGRect(x: selectedButton.frame.midX - textWidth / 2,
                                   y: bounds.height - config.indicatorHeight,
                                   width: textWidth,
                                   height: config.indicatorHeight)
            
        case .fullWidth:
            // 充满整个按钮宽度
            indicatorFrame = CGRect(x: selectedButton.frame.origin.x,
                                   y: bounds.height - config.indicatorHeight,
                                   width: selectedButton.frame.width,
                                   height: config.indicatorHeight)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.frame = indicatorFrame
            }
        } else {
            indicatorView.frame = indicatorFrame
        }
    }
    
    private func animateIndicator() {
        updateIndicatorFrame(animated: true)
    }
    
    // MARK: - 事件处理
    
    private func createDividerView() -> UIView {
        let view = UIView()
        view.backgroundColor = config.dividerColor
        return view
    }
    
    // MARK: - 事件处理
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    // MARK: - 布局
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算每个按钮的宽度
        let totalSpacing = config.itemSpacing * CGFloat(titles.count - 1)
        let totalButtonWidth = bounds.width - config.contentInsets.left - config.contentInsets.right - totalSpacing
        let buttonWidth = totalButtonWidth / CGFloat(titles.count)
        
        // 布局每个按钮
        for (index, button) in segmentButtons.enumerated() {
            let buttonX = config.contentInsets.left + CGFloat(index) * (buttonWidth + config.itemSpacing)
            button.frame = CGRect(x: buttonX,
                                 y: config.contentInsets.top,
                                 width: buttonWidth,
                                 height: bounds.height - config.contentInsets.top - config.contentInsets.bottom - config.indicatorHeight)
            
            // 布局分割线
            if config.showDivider && index < titles.count - 1,
               index < dividerViews.count {
                let dividerView = dividerViews[index]
                let dividerX = buttonX + buttonWidth + config.itemSpacing / 2 - config.dividerWidth / 2
                let buttonHeight = bounds.height - config.contentInsets.top - config.contentInsets.bottom - config.indicatorHeight
                let dividerHeight = buttonHeight * config.dividerHeightRatio
                let dividerY = config.contentInsets.top + (buttonHeight - dividerHeight) / 2
                
                dividerView.frame = CGRect(x: dividerX,
                                         y: dividerY,
                                         width: config.dividerWidth,
                                         height: dividerHeight)
            }
        }
        
        // 更新指示器位置
        updateIndicatorFrame(animated: false)
    }
    
    // MARK: - 尺寸计算
    
    override public var intrinsicContentSize: CGSize {
        // 计算合适的高度
        let height = config.font.lineHeight + config.contentInsets.top + config.contentInsets.bottom + config.indicatorHeight + 10
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}
