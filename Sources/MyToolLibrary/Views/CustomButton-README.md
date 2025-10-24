# ChimpionButton 使用指南

## 简介

`ChimpionButton` 是一个高度可定制的 UIButton 子类，基于 iOS 15.0+ 的 UIButtonConfiguration API 构建，提供了灵活的图标和文本布局配置功能。您可以轻松设置图标和文本的相对位置、间距，以及图片的最大尺寸限制，使按钮的外观完全符合您的设计需求。

## 特性

- 基于 iOS 15.0+ 的 UIButtonConfiguration API 构建
- 支持四种图标位置：左侧、右侧、顶部和底部
- 可自定义图标与文本之间的间距
- 可设置图片的最大尺寸限制
- 支持自定义图片缩放模式
- 自动处理只有图标或只有文本的情况
- 提供便捷的配置方法
- 自动处理安全区域和内容边距
- 完善的安全检查，避免潜在崩溃

## 快速开始

### 1. 导入组件

```swift
import MyToolLibrary
```

### 2. 创建按钮

```swift
// 使用标准初始化
let button = ChimpionButton(frame: CGRect(x: 50, y: 100, width: 200, height: 50))

// 或使用 Storyboard/XIB 创建
// 直接在界面设计器中拖入 UIButton，然后将其类设置为 ChimpionButton
```

### 3. 配置基本属性

```swift
// 设置文本和图标
button.setTitle("提交", for: .normal)
button.setTitleColor(.black, for: .normal)
button.setImage(UIImage(named: "submit"), for: .normal)

// 设置按钮样式
button.backgroundColor = .lightGray
button.layer.cornerRadius = 8
button.layer.borderWidth = 1
button.layer.borderColor = UIColor.darkGray.cgColor

// 使用便捷方法一次性配置所有内容
button.set(
    title: "提交",
    image: UIImage(named: "submit"),
    position: .left,
    spacing: 12,
    maxImageSize: CGSize(width: 24, height: 24)
)
```

## 图标位置配置

`ChimpionButton` 支持四种图标位置，通过 `imagePosition` 属性设置：

```swift
// 图标在文本左侧（默认）
button.imagePosition = .left

// 图标在文本右侧
button.imagePosition = .right

// 图标在文本上方
button.imagePosition = .top

// 图标在文本下方
button.imagePosition = .bottom
```

## 间距和尺寸配置

```swift
// 设置图标与文本之间的间距
button.spacing = 12

// 设置图片的最大尺寸限制
button.maxImageSize = CGSize(width: 24, height: 24)

// 或使用便捷方法设置图片最大尺寸
button.setMaxImageSize(width: 24, height: 24)

// 移除图片尺寸限制，使用原始尺寸
button.removeMaxImageSize()
```

## 图片缩放模式和内容边距

```swift
// 设置图片缩放模式
button.imageScaleMode = .scaleAspectFit  // 按比例缩放适应（默认）
// button.imageScaleMode = .scaleAspectFill // 按比例缩放填充
// button.imageScaleMode = .center // 居中不缩放

// 设置内容边距（支持 RTL 布局）
button.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
```

## 处理点击事件

```swift
// 添加点击事件监听
button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

// 事件处理方法
@objc func buttonTapped() {
    print("按钮被点击了！")
}
```

## 完整示例

### 示例 1: 图标在左侧的标准按钮

```swift
let leftIconButton = ChimpionButton(frame: CGRect(x: 50, y: 100, width: 200, height: 50))
leftIconButton.setTitle("添加到购物车", for: .normal)
leftIconButton.setTitleColor(.white, for: .normal)
leftIconButton.setImage(UIImage(named: "cart"), for: .normal)
leftIconButton.backgroundColor = .systemBlue
leftIconButton.layer.cornerRadius = 25
leftIconButton.imagePosition = .left
leftIconButton.spacing = 8
leftIconButton.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
leftIconButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
view.addSubview(leftIconButton)
```

### 示例 2: 图标在顶部的按钮

```swift
// 方法一：单独设置各项属性
let topIconButton = ChimpionButton(frame: CGRect(x: 50, y: 200, width: 120, height: 100))
topIconButton.setTitle("下载应用", for: .normal)
topIconButton.setTitleColor(.black, for: .normal)
topIconButton.setImage(UIImage(named: "download"), for: .normal)
topIconButton.backgroundColor = .systemGreen.withAlphaComponent(0.2)
topIconButton.layer.cornerRadius = 12
topIconButton.imagePosition = .top
topIconButton.spacing = 12
topIconButton.maxImageSize = CGSize(width: 32, height: 32)
topIconButton.addTarget(self, action: #selector(downloadApp), for: .touchUpInside)
view.addSubview(topIconButton)

// 方法二：使用便捷方法一次性配置
// 创建新的按钮实例以避免重复声明
let anotherTopButton = ChimpionButton(frame: CGRect(x: 200, y: 200, width: 120, height: 100))
anotherTopButton.set(
    title: "下载应用",
    image: UIImage(named: "download"),
    position: .top,
    spacing: 12,
    maxImageSize: CGSize(width: 32, height: 32)
)
anotherTopButton.setTitleColor(.black, for: .normal)
anotherTopButton.backgroundColor = .systemGreen.withAlphaComponent(0.2)
anotherTopButton.layer.cornerRadius = 12
anotherTopButton.addTarget(self, action: #selector(downloadApp), for: .touchUpInside)
view.addSubview(anotherTopButton)
```

### 示例 3: 只有图标的圆形按钮

```swift
let iconOnlyButton = ChimpionButton(frame: CGRect(x: 300, y: 100, width: 60, height: 60))
iconOnlyButton.setImage(UIImage(named: "settings"), for: .normal)
iconOnlyButton.backgroundColor = .systemGray
iconOnlyButton.layer.cornerRadius = 30
iconOnlyButton.clipsToBounds = true
iconOnlyButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
view.addSubview(iconOnlyButton)
```

### 示例 4: 图标在右侧的文字按钮

```swift
let rightIconButton = ChimpionButton(frame: CGRect(x: 50, y: 320, width: 250, height: 50))
rightIconButton.setTitle("了解更多详情", for: .normal)
rightIconButton.setTitleColor(.systemBlue, for: .normal)
rightIconButton.setImage(UIImage(named: "arrow_right"), for: .normal)
rightIconButton.backgroundColor = .systemBlue.withAlphaComponent(0.1)
rightIconButton.layer.cornerRadius = 8
rightIconButton.imagePosition = .right
rightIconButton.spacing = 10
rightIconButton.addTarget(self, action: #selector(learnMore), for: .touchUpInside)
view.addSubview(rightIconButton)
```

## 注意事项

1. **iOS 版本要求**：此组件基于 iOS 15.0+ 的 UIButtonConfiguration API 构建，确保您的项目支持此最低版本
2. **内容自适应**：按钮会根据设置的文本和图标自动调整内部布局
3. **约束更新**：当修改图标位置、间距等属性时，按钮会自动调用 `setNeedsLayout()` 进行重新布局
4. **尺寸限制**：设置 `maxImageSize` 时，图片会按比例缩放以适应限制，保持原始宽高比
5. **空值处理**：如果文本或图标为空，按钮会自动调整布局以适应剩余内容
6. **内边距设置**：使用 `contentInsets` 属性（基于 NSDirectionalEdgeInsets）调整按钮内容的内边距，支持 RTL 布局
7. **背景色管理**：支持通过 `setBackgroundColor(_:for:)` 方法为不同状态设置不同的背景色
8. **继承关系**：`ChimpionButton` 继承自 `UIButton`，完全支持标准 UIButton 的所有功能和状态管理

## 高级用法

### 动态改变按钮状态

```swift
// 禁用状态
button.isEnabled = false
button.setTitle("处理中...", for: .disabled)
button.setTitleColor(.gray, for: .disabled)

// 选中状态
button.isSelected = true
button.setTitle("已选中", for: .selected)
button.setTitleColor(.systemGreen, for: .selected)

// 高亮状态
button.isHighlighted = true
// 或通过交互自动触发高亮状态

### 结合自动布局使用

```swift
let button = ChimpionButton()
button.translatesAutoresizingMaskIntoConstraints = false
button.setTitle("自动布局按钮", for: .normal)
button.setImage(UIImage(named: "icon"), for: .normal)
button.imagePosition = .left
button.spacing = 8
button.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
button.maxImageSize = CGSize(width: 24, height: 24)
view.addSubview(button)

// 设置约束
NSLayoutConstraint.activate([
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
    button.widthAnchor.constraint(equalToConstant: 200),
    button.heightAnchor.constraint(equalToConstant: 50)
])
```
