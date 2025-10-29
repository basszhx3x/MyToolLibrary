//
//  RadioButtonTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

class RadioButtonTestViewController: UIViewController {
    
    // 单选按钮组
    private let basicRadioGroup = ChimpionRadioButtonGroup()
    private let customStyleRadioGroup = ChimpionRadioButtonGroup()
    private let colorRadioGroup = ChimpionRadioButtonGroup()
    private let sizeRadioGroup = ChimpionRadioButtonGroup()
    private let selectionModeRadioGroup = ChimpionRadioButtonGroup()
    private let fontConfigRadioGroup = ChimpionRadioButtonGroup()
    
    // UI元素
    private var selectedOptionLabel: UILabel!
    private var multipleSelectionLabel: UILabel!
    private var selectionModeButton: UIButton!
    
    // 数据
    private let colorOptions = ["红色", "蓝色", "绿色", "黄色", "紫色"]
    private let sizeOptions = ["小", "中", "大"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题和背景色
        title = "单选按钮测试"
        view.backgroundColor = .white
        
        // 创建UI组件
        setupUI()
    }
    
    private func setupUI() {
        // 创建滚动视图以适应所有内容
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)
        
        // 创建主容器视图
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 创建标题标签
        let titleLabel = createTitleLabel(text: "ChimpionRadioButton 测试")
        
        // 创建选中状态显示标签
        selectedOptionLabel = createStatusLabel(text: "请选择一个选项")
        
        // 创建多选选中状态显示标签
        multipleSelectionLabel = createStatusLabel(text: "请选择选项 (多选模式)")
        
        // 创建各个部分的视图
        let basicGroupView = createBasicRadioButtonGroup()
        let customStyleGroupView = createCustomStyleRadioButtonGroup()
        let colorGroupView = createColorCustomizationSection()
        let sizeGroupView = createSizeCustomizationSection()
        let selectionModeView = createMultipleSelectionSection()
        
        // 创建字体配置部分
        let fontConfigGroupView = createFontConfigSection()
        
        // 创建主垂直堆栈视图
        let mainStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            selectedOptionLabel,
            basicGroupView,
            customStyleGroupView,
            multipleSelectionLabel,
            selectionModeView,
            colorGroupView,
            sizeGroupView,
            fontConfigGroupView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 主堆栈视图约束
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // 设置标签宽度约束
            titleLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            selectedOptionLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            multipleSelectionLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    // MARK: - 通用UI创建方法
    
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
    
    private func createStatusLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
    
    private func createSectionTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - 按钮组创建方法
    
    private func createBasicRadioButtonGroup() -> UIView {
        return createRadioButtonSection(
            title: "基本单选按钮组",
            options: ["选项 1", "选项 2", "选项 3", "选项 4", "选项 5"],
            radioGroup: basicRadioGroup
        ) { [weak self] index in
            if let index = index {
                self?.selectedOptionLabel.text = "选中: \(index + 1)"
            } else {
                self?.selectedOptionLabel.text = "未选中任何选项"
            }
        }
    }
    
    private func createCustomStyleRadioButtonGroup() -> UIView {
        let options = ["自定义样式 A", "自定义样式 B", "自定义样式 C"]
        let colors: [UIColor] = [.systemGreen, .systemOrange, .systemPurple]
        let sizes: [CGFloat] = [18, 22, 26]
        
        return createRadioButtonSection(
            title: "自定义样式单选按钮组",
            options: options,
            radioGroup: customStyleRadioGroup
        ) { [weak self] index in
            if let index = index {
                self?.selectedOptionLabel.text = "选中自定义样式: \(options[index])"
            }
        } buttonCustomizer: { button, index in
            button.selectedColor = colors[index]
            button.unselectedColor = colors[index].withAlphaComponent(0.3)
            button.selectedTextColor = colors[index]
            button.buttonSize = sizes[index]
            button.borderWidth = 1.5
        }
    }
    
    private func createColorCustomizationSection() -> UIView {
        return createRadioButtonSection(
            title: "颜色选择",
            options: colorOptions,
            radioGroup: colorRadioGroup
        ) { [weak self] index in
            if let index = index, let self = self {
                self.selectedOptionLabel.text = "选择了颜色: \(self.colorOptions[index])"
            }
        } buttonCustomizer: { [weak self] button, index in
            if let self = self {
                button.selectedColor = self.getColor(for: index)
                button.selectedTextColor = self.getColor(for: index)
            }
        }
    }
    
    private func createSizeCustomizationSection() -> UIView {
        return createRadioButtonSection(
            title: "尺寸选择",
            options: sizeOptions.enumerated().map { "\($0.element)尺寸 (\(self.getSizeValue(for: $0.offset)))px" },
            radioGroup: sizeRadioGroup
        ) { [weak self] index in
            if let index = index, let self = self {
                self.selectedOptionLabel.text = "选择了尺寸: \(self.sizeOptions[index]) (\(self.getSizeValue(for: index)))px"
            }
        } buttonCustomizer: { [weak self] button, index in
            if let self = self {
                button.buttonSize = self.getSizeValue(for: index)
            }
        }
    }
    
    private func createMultipleSelectionSection() -> UIView {
        let sectionContainer = createSectionContainer()
        let sectionTitle = createSectionTitle(text: "多选模式测试")
        
        // 创建模式切换按钮
        selectionModeButton = UIButton(type: .system)
        selectionModeButton.setTitle("切换到多选模式", for: .normal)
        selectionModeButton.setTitleColor(.systemBlue, for: .normal)
        selectionModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        selectionModeButton.translatesAutoresizingMaskIntoConstraints = false
        selectionModeButton.addTarget(self, action: #selector(toggleSelectionMode), for: .touchUpInside)
        
        let options = ["多选选项 1 多选选项", "多选选项 2", "多选选项 3", "多选选项 4", "多选选项 5"]
        
        // 创建单选按钮堆栈视图
        let stackView = createRadioButtonsStackView(
            options: options,
            radioGroup: selectionModeRadioGroup
        ) { [weak self] index in
            if let index = index {
                self?.multipleSelectionLabel.text = "已选择: \(options[index])"
            } else {
                self?.multipleSelectionLabel.text = "未选择任何选项"
            }
        } buttonCustomizer: { button, _ in
            button.selectedColor = .systemGreen
            button.hideSelectedBackground = true
        }
        
        // 默认设置为单选模式
        selectionModeRadioGroup.selectionMode = .single
        
        // 设置多选变化回调
        selectionModeRadioGroup.onMultipleSelectionChanged = { [weak self] indices in
            if indices.isEmpty {
                self?.multipleSelectionLabel.text = "未选择任何选项"
            } else {
                let selectedOptions = indices.sorted().map { index in
                    guard index >= 0 && index < options.count else { return "" }
                    return options[index]
                }.joined(separator: ", ")
                self?.multipleSelectionLabel.text = "已选择: \(selectedOptions)"
            }
        }
        
        // 添加子视图并设置约束
        sectionContainer.addSubview(sectionTitle)
        sectionContainer.addSubview(selectionModeButton)
        sectionContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: sectionContainer.topAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: sectionContainer.leadingAnchor),
            sectionTitle.widthAnchor.constraint(equalTo: sectionContainer.widthAnchor),
            
            selectionModeButton.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 8),
            selectionModeButton.leadingAnchor.constraint(equalTo: sectionContainer.leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: selectionModeButton.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: sectionContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: sectionContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: sectionContainer.bottomAnchor)
        ])
        
        return sectionContainer
    }
    
    // MARK: - 辅助方法
    
    private func createSectionContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    private func createRadioButtonsStackView(
        options: [String],
        radioGroup: ChimpionRadioButtonGroup,
        selectionCallback: @escaping (Int?) -> Void,
        buttonCustomizer: ((ChimpionRadioButton, Int) -> Void)? = nil
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, option) in options.enumerated() {
            let radioButton = ChimpionRadioButton()
            radioButton.setTitle(option, for: .normal)
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            
            // 应用自定义样式（如果提供）
            buttonCustomizer?(radioButton, index)
            
            // 添加到单选按钮组
            radioGroup.addButton(radioButton)
            
            // 添加到堆栈视图
            stackView.addArrangedSubview(radioButton)
            
            // 设置宽度约束，使按钮宽度与堆栈视图一致
            radioButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            
            // 添加点击处理
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped(_:)))
            radioButton.addGestureRecognizer(tapGesture)
            radioButton.isUserInteractionEnabled = true
            radioButton.tag = index
        }
        
        // 设置选择回调
        radioGroup.onSelectionChanged = selectionCallback
        
        return stackView
    }
    
    private func setupSectionConstraints(sectionView: UIView, sectionTitle: UILabel, stackView: UIStackView) {
        sectionView.addSubview(sectionTitle)
        sectionView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: sectionView.topAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            
            // 为sectionTitle设置宽度约束，使其与sectionView一致
            sectionTitle.widthAnchor.constraint(equalTo: sectionView.widthAnchor)
        ])
    }
    
    private func createRadioButtonSection(
        title: String,
        options: [String],
        radioGroup: ChimpionRadioButtonGroup,
        selectionCallback: @escaping (Int?) -> Void,
        buttonCustomizer: ((ChimpionRadioButton, Int) -> Void)? = nil
    ) -> UIView {
        // 创建部分容器视图
        let sectionContainer = UIView()
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        sectionContainer.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        // 创建部分标题
        let sectionTitle = createSectionTitle(text: title)
        
        // 创建单选按钮堆栈视图
        let stackView = createRadioButtonsStackView(options: options, radioGroup: radioGroup, selectionCallback: selectionCallback, buttonCustomizer: buttonCustomizer)
        
        // 添加子视图并设置约束
        setupSectionConstraints(sectionView: sectionContainer, sectionTitle: sectionTitle, stackView: stackView)
        
        return sectionContainer
    }
    
    // MARK: - 动作和辅助方法
    
    @objc private func toggleSelectionMode() {
        // 切换选择模式
        if selectionModeRadioGroup.selectionMode == .single {
            selectionModeRadioGroup.selectionMode = .multiple
            selectionModeButton.setTitle("切换到单选模式", for: .normal)
            
            // 如果有选中项，转换为多选
            if let selectedIndex = selectionModeRadioGroup.selectedIndex {
                selectionModeRadioGroup.setMultipleSelection([selectedIndex])
            }
        } else {
            selectionModeRadioGroup.selectionMode = .single
            selectionModeButton.setTitle("切换到多选模式", for: .normal)
            
            // 保留第一个选中项
            if let firstSelectedIndex = selectionModeRadioGroup.selectedIndices.first {
                selectionModeRadioGroup.setSelected(at: firstSelectedIndex)
            }
        }
    }
    
    @objc private func radioButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let radioButton = sender.view as? ChimpionRadioButton else { return }
        
        // 触发按钮的valueChanged事件，由ChimpionRadioButtonGroup统一管理状态
        radioButton.sendActions(for: .valueChanged)
    }
    
    private func getColor(for index: Int) -> UIColor {
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
        return colors[min(index, colors.count - 1)]
    }
    
    private func getSizeValue(for index: Int) -> CGFloat {
        switch index {
        case 0: return 16
        case 1: return 24
        case 2: return 32
        default: return 20
        }
    }
    
    private func createFontConfigSection() -> UIView {
        return createRadioButtonSection(
            title: "字体配置测试",
            options: ["普通字体", "粗体", "斜体", "大字体", "小字体"],
            radioGroup: fontConfigRadioGroup
        ) { [weak self] index in
            if let index = index {
                let fontTypes = ["普通字体", "粗体", "斜体", "大字体", "小字体"]
                self?.selectedOptionLabel.text = "字体配置选中：\(fontTypes[index])"
            }
        } buttonCustomizer: { button, index in
            switch index {
            case 0: // 普通字体
                button.titleFont = UIFont.systemFont(ofSize: 16)
                button.unselectedTextColor = .black
                button.selectedTextColor = .blue
            case 1: // 粗体
                button.titleFont = UIFont.boldSystemFont(ofSize: 16)
                button.unselectedTextColor = .black
                button.selectedTextColor = .blue
            case 2: // 斜体
                button.titleFont = UIFont.italicSystemFont(ofSize: 16)
                button.unselectedTextColor = .black
                button.selectedTextColor = .blue
            case 3: // 大字体
                button.titleFont = UIFont.systemFont(ofSize: 20)
                button.unselectedTextColor = .black
                button.selectedTextColor = .blue
            case 4: // 小字体
                button.titleFont = UIFont.systemFont(ofSize: 12)
                button.unselectedTextColor = .black
                button.selectedTextColor = .blue
            default:
                break
            }
        }
    }
}
