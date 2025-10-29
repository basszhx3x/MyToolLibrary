//
//  ChimpionRadioButton.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit

/// 标题标签位置枚举
@available(iOS 15.0, *)
public enum TitleLabelSide {
    case left, right
}

/// 单选按钮配置结构体，用于集中管理按钮的所有外观和行为属性
@available(iOS 15.0, *)
public struct RadioConfig {
    /// 选中状态颜色
    public var selectedColor: UIColor
    /// 未选中状态颜色
    public var unselectedColor: UIColor
    /// 按钮大小
    public var buttonSize: CGFloat
    /// 边框宽度
    public var borderWidth: CGFloat
    /// 标题字体
    public var titleFont: UIFont
    /// 标题与按钮间的内边距
    public var titlePadding: CGFloat
    /// 背景颜色
    public var backgroundColor: UIColor
    /// 是否使用透明背景
    public var isTransparentBackground: Bool
    /// 选中状态文字颜色
    public var selectedTextColor: UIColor
    /// 未选中状态文字颜色
    public var unselectedTextColor: UIColor
    /// 选中状态自定义图片
    public var selectedImage: UIImage?
    /// 未选中状态自定义图片
    public var unselectedImage: UIImage?
    
    /// 配置结构体的默认初始化器
    public init(
        selectedColor: UIColor = .systemBlue,
        unselectedColor: UIColor = .systemGray3,
        buttonSize: CGFloat = 20,
        borderWidth: CGFloat = 2,
        titleFont: UIFont = .systemFont(ofSize: 16),
        textColor: UIColor = .label,
        titlePadding: CGFloat = 8,
        backgroundColor: UIColor = .white,
        isTransparentBackground: Bool = false,
        selectedTextColor: UIColor = .systemBlue,
        unselectedTextColor: UIColor = .systemGray,
        selectedImage: UIImage? = nil,
        unselectedImage: UIImage? = nil
    ) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.buttonSize = buttonSize
        self.borderWidth = borderWidth
        self.titleFont = titleFont
        self.titlePadding = titlePadding
        self.backgroundColor = backgroundColor
        self.isTransparentBackground = isTransparentBackground
        self.selectedTextColor = selectedTextColor
        self.unselectedTextColor = unselectedTextColor
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
}

/// 自定义单选按钮组件
/// - 注意: 仅支持iOS 15.0及以上版本
@available(iOS 15.0, *)
public class ChimpionRadioButton: UIButton {
    
    // MARK: - 配置属性
    
    /// 单选按钮配置
    public var radioConfig: RadioConfig {
        didSet {
            updateButtonAppearance()
        }
    }
    
    /// 选中状态颜色
    public var selectedColor: UIColor { 
        get { radioConfig.selectedColor } 
        set { radioConfig.selectedColor = newValue }
    }
    
    /// 未选中状态颜色
    public var unselectedColor: UIColor { 
        get { radioConfig.unselectedColor } 
        set { radioConfig.unselectedColor = newValue }
    }
    
    /// 选中状态文字颜色
    public var selectedTextColor: UIColor { 
        get { radioConfig.selectedTextColor } 
        set { 
            radioConfig.selectedTextColor = newValue 
            updateButtonAppearance() 
        }
    }
    
    /// 未选中状态文字颜色
    public var unselectedTextColor: UIColor { 
        get { radioConfig.unselectedTextColor } 
        set { 
            radioConfig.unselectedTextColor = newValue 
            updateButtonAppearance() 
        }
    }
    
    /// 选中状态自定义图片
    public var selectedImage: UIImage? { 
        get { radioConfig.selectedImage } 
        set { 
            radioConfig.selectedImage = newValue 
            updateButtonAppearance() 
        }
    }
    
    /// 未选中状态自定义图片
    public var unselectedImage: UIImage? { 
        get { radioConfig.unselectedImage } 
        set { 
            radioConfig.unselectedImage = newValue 
            updateButtonAppearance() 
        }
    }
    
    /// 按钮尺寸
    public var buttonSize: CGFloat { 
        get { radioConfig.buttonSize } 
        set { radioConfig.buttonSize = newValue }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat { 
        get { radioConfig.borderWidth } 
        set { radioConfig.borderWidth = newValue }
    }
    
    /// 是否隐藏选中状态的背景色
    /// 设置为true时，将移除UIButtonConfiguration.plain模式下默认的选中背景色
    public var hideSelectedBackground: Bool = false { 
        didSet { 
            updateButtonAppearance() 
        }
    }
    
    /// 标题字体设置
    public var titleFont: UIFont { 
        get { radioConfig.titleFont } 
        set { radioConfig.titleFont = newValue }
    }
    
    // MARK: - 初始化
    
    /// 使用配置初始化单选按钮
    /// - Parameter config: 单选按钮配置
    public init(config: RadioConfig) {
        self.radioConfig = config
        super.init(frame: .zero)
        setupButton()
    }
    
    override public init(frame: CGRect) {
        // 使用默认配置初始化
        self.radioConfig = RadioConfig()
        super.init(frame: frame)
        setupButton()
    }
    
    required public init?(coder: NSCoder) {
        // 使用默认配置初始化
        self.radioConfig = RadioConfig()
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // 设置按钮内容布局
        titleLabel?.font = radioConfig.titleFont
        titleLabel?.lineBreakMode = .byTruncatingTail // 设置文本截断模式
        titleLabel?.numberOfLines = 1 // 限制为单行
        
        // 设置按钮水平对齐方式（使用UIButton的传统方法）
        contentHorizontalAlignment = .left
        
        // 初始化UIButtonConfiguration
        var config = UIButton.Configuration.plain()
        
        // 设置按钮内边距：左侧8pt，右侧8pt，上下各5pt
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
        
        // 设置图片和标题之间的间距为5pt
        config.imagePadding = radioConfig.titlePadding
        
        // 应用配置
        self.configuration = config
        
        // 更新按钮外观
        updateButtonAppearance()
        
        // 添加点击事件
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func updateButtonSize() {
        // 使用UIButtonConfiguration处理布局，这里仅更新配置中的内边距和间距
        guard var config = configuration else { return }
        
        // 设置按钮内边距：左侧8pt，右侧8pt，上下各5pt
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
        
        // 设置图片和标题之间的间距
        config.imagePadding = radioConfig.titlePadding
        
        // 应用更新的配置
        self.configuration = config
    }
    
    // MARK: - 尺寸计算
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        // 设置默认宽度为120，确保按钮有足够的最小宽度
        let defaultWidth: CGFloat = 120
        // 设置默认高度为44
        let defaultHeight: CGFloat = 44
        
        // 确保宽度足够容纳文本内容
        if let titleLabel = titleLabel, let text = titleLabel.text, !text.isEmpty {
            let font = titleLabel.font ?? radioConfig.titleFont
            let textSize = (text as NSString).size(withAttributes: [.font: font])
            // 计算总宽度：图片宽度 + 文本宽度 + 左右内边距 + 间距
            let spacing: CGFloat = radioConfig.titlePadding // 图片和文本之间的间距
            let totalWidth = radioConfig.buttonSize + spacing + textSize.width + 10 // 右侧内边距
            // 取默认宽度和计算宽度的较大值
            size.width = max(defaultWidth, totalWidth)
        } else {
            // 如果没有文本，使用默认宽度
            size.width = defaultWidth
        }
        
        // 设置默认高度
        size.height = defaultHeight
        return size
    }
    
    private func updateButtonAppearance() {
        guard var config = configuration else { return }
        
        // 设置按钮图片
        if isSelected {
            if let customImage = radioConfig.selectedImage {
                config.image = customImage
            } else {
                config.image = createSelectedImage()
            }
        } else {
            if let customImage = radioConfig.unselectedImage {
                config.image = customImage
            } else {
                config.image = createUnselectedImage()
            }
        }
        
        // 控制是否隐藏选中背景色
        if hideSelectedBackground || radioConfig.isTransparentBackground {
            // 隐藏选中背景色时使用透明背景
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            config.background = backgroundConfig
            // 设置文字颜色
            config.baseForegroundColor = isSelected ? radioConfig.selectedTextColor : radioConfig.unselectedTextColor
            // 通过标题属性转换器设置字体
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.radioConfig.titleFont
                return outgoing
            }
        } else {
            // 使用UIButton.Configuration.plain的默认背景配置
            // 重新创建一个plain配置并保留我们的其他设置
            var plainConfig = UIButton.Configuration.plain()
            // 复制我们需要保留的设置
            plainConfig.contentInsets = config.contentInsets
            plainConfig.imagePadding = config.imagePadding
            plainConfig.image = config.image
            // 重要：复制title属性，确保title不会丢失
            plainConfig.title = config.title
            // 确保文字颜色设置正确，无论是否选中
            plainConfig.baseForegroundColor = isSelected ? radioConfig.selectedTextColor : radioConfig.unselectedTextColor
            // 通过标题属性转换器设置字体
            plainConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.radioConfig.titleFont
                return outgoing
            }
            // 使用plain配置替换当前配置
            config = plainConfig
        }
        
        // 应用更新的配置
        self.configuration = config
    }
    
    /// 创建选中状态的默认图片
    private func createSelectedImage() -> UIImage {
        // 确保有足够的空间来绘制完整圆形
        let diameter = radioConfig.buttonSize - radioConfig.borderWidth
        let size = CGSize(width: radioConfig.buttonSize, height: radioConfig.buttonSize)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            // 确保绘制上下文正确
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            
            // 创建一个中心在正确位置的圆形
            let center = CGPoint(x: radioConfig.buttonSize / 2, y: radioConfig.buttonSize / 2)
            
            // 绘制外圈
            let outerCirclePath = UIBezierPath(arcCenter: center, 
                                              radius: diameter / 2, 
                                              startAngle: 0, 
                                              endAngle: CGFloat.pi * 2, 
                                              clockwise: true)
            radioConfig.selectedColor.setStroke()
            outerCirclePath.lineWidth = radioConfig.borderWidth
            outerCirclePath.stroke()
            
            // 绘制内部实心圆
            let innerRadius = (diameter - radioConfig.borderWidth * 2) / 2 - 1
            let innerCirclePath = UIBezierPath(arcCenter: center,
                                              radius: innerRadius, 
                                              startAngle: 0, 
                                              endAngle: CGFloat.pi * 2, 
                                              clockwise: true)
            radioConfig.selectedColor.setFill()
            innerCirclePath.fill()
            
            context.restoreGState()
        }
    }
    
    /// 创建未选中状态的默认图片
    private func createUnselectedImage() -> UIImage {
        // 确保有足够的空间来绘制完整圆形
        let diameter = radioConfig.buttonSize - radioConfig.borderWidth
        let size = CGSize(width: radioConfig.buttonSize, height: radioConfig.buttonSize)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            // 确保绘制上下文正确
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            
            // 创建一个中心在正确位置的圆形
            let center = CGPoint(x: radioConfig.buttonSize / 2, y: radioConfig.buttonSize / 2)
            
            // 绘制外圈
            let outerCirclePath = UIBezierPath(arcCenter: center, 
                                              radius: diameter / 2, 
                                              startAngle: 0, 
                                              endAngle: CGFloat.pi * 2, 
                                              clockwise: true)
            radioConfig.unselectedColor.setStroke()
            outerCirclePath.lineWidth = radioConfig.borderWidth
            outerCirclePath.stroke()
            
            context.restoreGState()
        }
    }
    
    // MARK: - 事件处理
    
    @objc private func buttonTapped() {
        // 不直接切换状态，只发送事件，由RadioButtonGroup统一管理状态
        sendActions(for: .valueChanged)
    }
    
    // MARK: - 状态更新
    
    override public var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    // MARK: - 布局
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateButtonSize()
    }
}

// MARK: - 单选按钮组管理器

/// 选择模式枚举
@available(iOS 15.0, *)
public enum SelectionMode {
    /// 单选模式（默认）
    case single
    /// 多选模式
    case multiple
}

/// 单选/多选按钮组管理类，用于管理一组按钮的选中状态
@available(iOS 15.0, *)
public class ChimpionRadioButtonGroup {
    
    /// 单选按钮组中的所有按钮
    private var radioButtons: [ChimpionRadioButton] = []
    
    /// 当前选中的按钮索引（单选模式下）
    public var selectedIndex: Int?
    
    /// 当前选中的按钮索引集合（多选模式下）
    public var selectedIndices: Set<Int> = []
    
    /// 选择模式，默认为单选
    public var selectionMode: SelectionMode = .single {
        didSet {
            // 当切换模式时，重置选中状态
            if oldValue != selectionMode {
                if selectionMode == .single {
                    // 从多选切换到单选，使用多选集合中的第一个选项
                    if let firstSelectedIndex = selectedIndices.first {
                        setSelected(at: firstSelectedIndex)
                    } else {
                        setSelected(at: nil)
                    }
                } else {
                    // 从单选切换到多选，如果有选中项则加入集合
                    if let selectedIndex = selectedIndex {
                        var newSelection = Set<Int>()
                        newSelection.insert(selectedIndex)
                        setMultipleSelection(newSelection)
                    } else {
                        setMultipleSelection([])
                    }
                }
            }
        }
    }
    
    /// 选中状态改变的回调（单选模式）
    public var onSelectionChanged: ((Int?) -> Void)?
    
    /// 选中状态改变的回调（多选模式）
    public var onMultipleSelectionChanged: ((Set<Int>) -> Void)?
    
    /// 公开初始化器
    public init() {}

    
    /// 添加按钮到组
    /// - Parameter button: 要添加的单选按钮
    public func addButton(_ button: ChimpionRadioButton) {
        // 移除之前可能添加的目标，避免重复添加
        button.removeTarget(self, action: #selector(radioButtonTapped(_:)), for: .valueChanged)
        
        // 添加新的目标
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .valueChanged)
        
        // 添加到按钮数组
        radioButtons.append(button)
    }
    
    /// 从组中移除按钮
    /// - Parameter button: 要移除的单选按钮
    public func removeButton(_ button: ChimpionRadioButton) {
        if let index = radioButtons.firstIndex(of: button) {
            button.removeTarget(self, action: #selector(radioButtonTapped(_:)), for: .valueChanged)
            radioButtons.remove(at: index)
            
            // 如果移除的是当前选中的按钮，更新选中状态
            if selectedIndex == index {
                selectedIndex = nil
                onSelectionChanged?(nil)
            } else if let selectedIdx = selectedIndex, selectedIdx > index {
                // 如果移除的按钮在当前选中按钮之前，调整选中索引
                selectedIndex = selectedIdx - 1
            }
        }
    }
    
    /// 清除所有按钮
    public func clearAllButtons() {
        // 移除所有按钮的事件监听
        for button in radioButtons {
            button.removeTarget(self, action: #selector(radioButtonTapped(_:)), for: .valueChanged)
            button.isSelected = false
        }
        
        // 清空数组和选中状态
        radioButtons.removeAll()
        selectedIndex = nil
        onSelectionChanged?(nil)
    }
    
    /// 手动设置选中的按钮（单选模式）
    /// - Parameter index: 要选中的按钮索引
    public func setSelected(at index: Int?) {
        if selectionMode == .single {
            guard let index = index, index >= 0, index < radioButtons.count else {
                // 取消所有选中
                for button in radioButtons {
                    button.isSelected = false
                }
                selectedIndex = nil
                onSelectionChanged?(nil)
                return
            }
            
            // 更新选中状态
            for (i, button) in radioButtons.enumerated() {
                button.isSelected = (i == index)
            }
            
            // 更新选中索引
            selectedIndex = index
            onSelectionChanged?(index)
        } else {
            // 在多选模式下，可以调用setMultipleSelection方法
            if let index = index {
                var newSelection = selectedIndices
                if newSelection.contains(index) {
                    newSelection.remove(index)
                } else {
                    newSelection.insert(index)
                }
                setMultipleSelection(newSelection)
            } else {
                // 取消所有选中
                setMultipleSelection([])
            }
        }
    }
    
    /// 手动设置选中的按钮集合（多选模式）
    /// - Parameter indices: 要选中的按钮索引集合
    public func setMultipleSelection(_ indices: Set<Int>) {
        guard selectionMode == .multiple else {
            // 如果不是多选模式，只选择第一个索引
            if let firstIndex = indices.first {
                setSelected(at: firstIndex)
            }
            return
        }
        
        // 验证索引是否有效
        let validIndices = indices.filter { $0 >= 0 && $0 < radioButtons.count }
        
        // 更新按钮选中状态
        for (i, button) in radioButtons.enumerated() {
            button.isSelected = validIndices.contains(i)
        }
        
        // 更新选中索引集合
        selectedIndices = validIndices
        onMultipleSelectionChanged?(validIndices)
    }
    
    /// 获取当前选中的按钮集合（多选模式）
    /// - Returns: 选中的按钮数组
    public func getSelectedButtons() -> [ChimpionRadioButton] {
        return selectedIndices.compactMap { index in
            guard index >= 0 && index < radioButtons.count else {
                return nil
            }
            return radioButtons[index]
        }
    }
    
    /// 获取当前选中的按钮
    /// - Returns: 选中的按钮，如果没有选中的按钮则返回nil
    public func getSelectedButton() -> ChimpionRadioButton? {
        guard let index = selectedIndex, index >= 0, index < radioButtons.count else {
            return nil
        }
        return radioButtons[index]
    }
    
    // MARK: - 事件处理
    
    @objc private func radioButtonTapped(_ sender: ChimpionRadioButton) {
        guard let index = radioButtons.firstIndex(of: sender) else { return }
        
        if selectionMode == .single {
            // 单选模式逻辑
            if selectedIndex == index {
                // 如果点击的是已选中的按钮，取消选中
                for button in radioButtons {
                    button.isSelected = false
                }
                selectedIndex = nil
                selectedIndices.removeAll()
                onSelectionChanged?(nil)
            } else {
                // 更新所有按钮的选中状态
                for (i, button) in radioButtons.enumerated() {
                    button.isSelected = (i == index)
                }
                
                // 更新选中索引
                selectedIndex = index
                selectedIndices = [index] // 同时更新多选索引集合以保持一致性
                onSelectionChanged?(index)
            }
        } else {
            // 多选模式逻辑
            // 切换点击按钮的选中状态
            let newSelectedState = !selectedIndices.contains(index)
            
            // 更新选中索引集合
            if newSelectedState {
                selectedIndices.insert(index)
            } else {
                selectedIndices.remove(index)
            }
            
            // 确保所有按钮状态与索引集合一致
            for (i, button) in radioButtons.enumerated() {
                button.isSelected = selectedIndices.contains(i)
            }
            
            // 更新单选索引（如果需要）
            if selectedIndices.count == 1, let singleIndex = selectedIndices.first {
                selectedIndex = singleIndex
            } else if selectedIndices.isEmpty {
                selectedIndex = nil
            } else {
                // 多选时，单选索引设为nil
                selectedIndex = nil
            }
            
            onMultipleSelectionChanged?(selectedIndices)
        }
    }
}
