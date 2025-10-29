# ChimpionRadioButton 使用指南

## 简介

`ChimpionRadioButton` 是一个自定义的单选按钮组件，支持丰富的样式配置和灵活的使用方式。它可以作为独立的单选按钮使用，也可以通过 `ChimpionRadioButtonGroup` 进行分组管理，实现真正的单选功能。

## 特性

- 支持自定义选中和未选中状态的颜色
- 支持自定义文字颜色
- 支持自定义选中和未选中的图标
- 可配置按钮尺寸和边框宽度
- 内置单选按钮组管理器，方便实现多选一功能
- 提供选中状态变化的回调

## 快速开始

### 1. 导入组件

```swift
import MyToolLibrary
```

### 2. 创建单个单选按钮

```swift
// 创建单选按钮
let radioButton = ChimpionRadioButton()
radioButton.setTitle("选项 1", for: .normal)
radioButton.selectedColor = .systemGreen
radioButton.unselectedColor = .lightGray
radioButton.buttonSize = 24

// 添加到视图
view.addSubview(radioButton)

// 设置约束（使用Auto Layout）
radioButton.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    radioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    radioButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])

// 监听选中状态变化
radioButton.addTarget(self, action: #selector(radioButtonValueChanged(_:)), for: .valueChanged)

@objc private func radioButtonValueChanged(_ sender: ChimpionRadioButton) {
    print("单选按钮状态: \(sender.isSelected ? "选中" : "未选中")")
}
```

### 3. 创建单选按钮组

```swift
// 创建单选按钮组管理器
let radioGroup = ChimpionRadioButtonGroup()

// 设置选中变化回调
radioGroup.onSelectionChanged = { [weak self] index in
    if let index = index {
        print("选中了索引: \(index)")
    } else {
        print("没有选中任何选项")
    }
}

// 创建多个单选按钮
let buttonTitles = ["选项 A", "选项 B", "选项 C"]
for (index, title) in buttonTitles.enumerated() {
    let button = ChimpionRadioButton()
    button.setTitle(title, for: .normal)

    // 添加到按钮组
    radioGroup.addButton(button)

    // 添加到视图
    stackView.addArrangedSubview(button)
}

// 手动设置选中状态
radioGroup.setSelected(at: 0) // 默认选中第一个选项
```

## RadioConfig 配置结构体

`ChimpionRadioButton` 使用 `RadioConfig` 结构体来集中管理所有配置选项。这样可以更方便地创建、复用和切换不同的样式配置。

### RadioConfig 属性说明

```swift
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
    /// 圆角半径
    public var cornerRadius: CGFloat
    /// 标题标签位置
    public var titleLabelSide: TitleLabelSide
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
}
```

### 使用 RadioConfig

```swift
// 创建自定义配置
let customConfig = RadioConfig(
    selectedColor: .systemGreen,
    unselectedColor: .lightGray,
    buttonSize: 24,
    borderWidth: 2,
    titleFont: .systemFont(ofSize: 16, weight: .medium),
    cornerRadius: 12,
    titleLabelSide: .right,
    titlePadding: 10,
    backgroundColor: .white,
    isTransparentBackground: false,
    selectedTextColor: .systemGreen,
    unselectedTextColor: .darkGray,
    selectedImage: UIImage(named: "customSelectedIcon"),
    unselectedImage: UIImage(named: "customUnselectedIcon")
)

// 应用配置到单选按钮
radioButton.radioConfig = customConfig
```

### 直接配置属性

除了使用 `RadioConfig` 外，你也可以直接设置单选按钮的各个属性：

#### 颜色配置

```swift
// 设置选中状态颜色
radioButton.selectedColor = UIColor.systemBlue

// 设置未选中状态颜色
radioButton.unselectedColor = UIColor.systemGray3

// 设置选中状态文字颜色
radioButton.selectedTextColor = UIColor.systemBlue

// 设置未选中状态文字颜色
radioButton.unselectedTextColor = UIColor.systemGray
```

#### 图标配置

```swift
// 设置自定义选中图标
radioButton.selectedImage = UIImage(named: "customSelectedIcon")

// 设置自定义未选中图标
radioButton.unselectedImage = UIImage(named: "customUnselectedIcon")
```

#### 尺寸配置

```swift
// 设置按钮尺寸
radioButton.buttonSize = 22

// 设置边框宽度
radioButton.borderWidth = 2
```

## 单选按钮组管理

### 添加和移除按钮

```swift
// 添加按钮到组
radioGroup.addButton(radioButton)

// 从组中移除按钮
radioGroup.removeButton(radioButton)

// 清空所有按钮
radioGroup.clearAllButtons()
```

### 获取选中状态

```swift
// 获取当前选中的索引
if let selectedIndex = radioGroup.selectedIndex {
    print("选中的索引: \(selectedIndex)")
}

// 获取当前选中的按钮
if let selectedButton = radioGroup.getSelectedButton() {
    print("选中的按钮标题: \(selectedButton.titleLabel?.text ?? "未知")")
}
```

## 完整示例

下面是一个完整的示例，展示如何创建一个包含多个选项的单选按钮组，并使用 RadioConfig 进行配置：

```swift
import UIKit
import MyToolLibrary

class RadioButtonExampleViewController: UIViewController {

    private let radioGroup = ChimpionRadioButtonGroup()
    private var selectedOptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置背景色
        view.backgroundColor = .white

        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "单选按钮示例"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        // 创建选中状态显示标签
        selectedOptionLabel = UILabel()
        selectedOptionLabel.text = "未选中任何选项"
        selectedOptionLabel.font = UIFont.systemFont(ofSize: 16)
        selectedOptionLabel.textAlignment = .center
        selectedOptionLabel.textColor = .systemBlue

        // 创建垂直堆栈视图
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading

        // 创建选项数据
        let options = ["红色", "蓝色", "绿色", "黄色", "紫色"]
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]

        // 创建并配置单选按钮
        for (index, option) in options.enumerated() {
            // 使用RadioConfig创建自定义配置
            let customConfig = RadioConfig(
                selectedColor: colors[index],
                unselectedColor: .lightGray,
                buttonSize: 24,
                borderWidth: 2,
                titleFont: .systemFont(ofSize: 16),
                selectedTextColor: colors[index],
                unselectedTextColor: .systemGray,
                titlePadding: 10
            )

            // 创建单选按钮并应用配置
            let radioButton = ChimpionRadioButton()
            radioButton.setTitle(option, for: .normal)
            radioButton.radioConfig = customConfig

            // 添加到按钮组
            radioGroup.addButton(radioButton)

            // 添加到堆栈视图
            stackView.addArrangedSubview(radioButton)
        }

        // 设置选中变化回调
        radioGroup.onSelectionChanged = { [weak self] index in
            guard let self = self else { return }

            if let index = index {
                self.selectedOptionLabel.text = "选中: \(options[index])"
            } else {
                self.selectedOptionLabel.text = "未选中任何选项"
            }
        }

        // 添加所有视图到主视图
        [titleLabel, selectedOptionLabel, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // 设置约束
        NSLayoutConstraint.activate([
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // 选中状态标签约束
            selectedOptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            selectedOptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedOptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // 堆栈视图约束
            stackView.topAnchor.constraint(equalTo: selectedOptionLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        // 默认选中第一个选项
        radioGroup.setSelected(at: 0)
    }
}
```

## 注意事项

1. 当使用单选按钮组时，请确保使用 `ChimpionRadioButtonGroup` 来管理按钮的选中状态，而不是直接修改单个按钮的 `isSelected` 属性。

2. 自定义图片时，请注意图片的尺寸应与 `buttonSize` 属性相匹配，以获得最佳显示效果。

3. 如需在表格视图或集合视图中使用，请确保正确管理按钮组和单元格的复用逻辑。

4. 所有配置属性都支持动态更新，修改后会立即反映到 UI 上。
