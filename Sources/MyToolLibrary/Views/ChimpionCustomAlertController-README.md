# ChimpionCustomAlertController 使用指南

## 简介

`ChimpionCustomAlertController` 是一个高度灵活的自定义弹窗控制器，允许您显示任何自定义视图作为弹窗内容。它会智能处理视图的布局和尺寸，支持点击外部区域关闭弹窗，并提供了简单易用的 API。

## 特性

- 支持显示任何自定义 UIView 作为弹窗内容
- 智能处理视图尺寸：
  - 如果视图有明确的宽高约束，使用视图的宽高在屏幕中心显示
  - 如果没有明确宽高，距离左右边距 20，高度最小 300，并自动计算合适的尺寸
- 支持点击弹窗外部区域关闭弹窗（可配置开关）
- 提供优雅的淡入淡出过渡动画
- 支持便捷的扩展方法调用
- 自动处理圆角和阴影效果
- 高度可定制的外观（通过配置对象）
- 子视图会被正确裁剪在圆角范围内
- 支持底部关闭按钮（可配置显示/隐藏）

## 快速开始

### 1. 导入库

在需要使用的文件中导入：

```swift
import MyToolLibrary
```

### 2. 创建自定义内容视图

```swift
// 创建自定义内容视图
let customView = UIView()
customView.backgroundColor = .white

// 添加一些子视图，例如标签和按钮
let titleLabel = UILabel()
titleLabel.text = "自定义弹窗"
titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
titleLabel.translatesAutoresizingMaskIntoConstraints = false

let messageLabel = UILabel()
messageLabel.text = "这是一个使用ChimpionCustomAlertController显示的自定义弹窗内容"
messageLabel.numberOfLines = 0
messageLabel.translatesAutoresizingMaskIntoConstraints = false

let closeButton = UIButton(type: .system)
closeButton.setTitle("关闭", for: .normal)
closeButton.backgroundColor = .systemBlue
closeButton.setTitleColor(.white, for: .normal)
closeButton.layer.cornerRadius = 8
closeButton.translatesAutoresizingMaskIntoConstraints = false

// 添加子视图
customView.addSubview(titleLabel)
customView.addSubview(messageLabel)
customView.addSubview(closeButton)

// 设置约束
NSLayoutConstraint.activate([
    // 设置自定义视图的尺寸
    customView.widthAnchor.constraint(equalToConstant: 300),  // 明确指定宽度
    customView.heightAnchor.constraint(equalToConstant: 200), // 明确指定高度

    // 子视图约束
    titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
    titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
    titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),

    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
    messageLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
    messageLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),

    closeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
    closeButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
    closeButton.widthAnchor.constraint(equalToConstant: 100),
    closeButton.heightAnchor.constraint(equalToConstant: 40),
    closeButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -20)
])
```

### 3. 显示自定义弹窗

#### 方法一：使用默认配置

```swift
// 创建并显示自定义弹窗（使用默认配置）
let alertController = ChimpionCustomAlertController(contentView: customView)

// 显示弹窗
alertController.show(in: self)

// 为关闭按钮添加点击事件
closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

@objc func closeButtonTapped() {
    // 如果能获取到alertController实例，可以直接调用dismiss方法
    alertController.dismissAlert()
}
```

#### 方法二：使用自定义配置

```swift
// 创建自定义配置
let customConfig = ChimpionAlertConfig(
    cornerRadius: 20,              // 圆角大小
    shadowColor: .darkGray,        // 阴影颜色
    shadowOpacity: 0.3,            // 阴影透明度
    shadowOffset: CGSize(width: 0, height: 4), // 阴影偏移
    shadowRadius: 12,              // 阴影半径
    backgroundColor: .lightGray,   // 背景颜色
    backgroundOpacity: 0.7,        // 背景遮罩透明度
    allowTapOutsideToDismiss: true, // 是否允许点击外部关闭
    minHeight: 400,                // 最小高度
    horizontalPadding: 30,         // 左右边距
    maxWidth: 500,                 // 最大宽度
    maxHeightRatio: 0.9            // 最大高度比例（相对于屏幕高度）
)

// 创建并显示自定义弹窗（使用自定义配置）
let alertController = ChimpionCustomAlertController(contentView: customView, config: customConfig)
alertController.show(in: self)
```

#### 方法三：使用便捷扩展方法

```swift
// 使用UIViewController的扩展方法显示弹窗（使用默认配置）
let alertController = self.showChimpionAlert(contentView: customView)

// 使用UIViewController的扩展方法显示弹窗（使用自定义配置）
let alertController = self.showChimpionAlert(contentView: customView, config: customConfig)

// 使用UIViewController的扩展方法显示弹窗（仅设置是否允许点击外部关闭，兼容旧版API）
let alertController = self.showChimpionAlert(contentView: customView, allowTapOutsideToDismiss: true)

// 为关闭按钮添加点击事件
closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

@objc func closeButtonTapped() {
    alertController.dismissAlert()
}
```

## 配置对象详解

`ChimpionAlertConfig` 结构体提供了丰富的配置选项，让您可以完全自定义弹窗的外观和行为：

### 配置选项

- **cornerRadius**: 弹窗的圆角大小，默认值为 12
- **shadowColor**: 弹窗的阴影颜色，默认值为黑色
- **shadowOpacity**: 弹窗的阴影透明度，默认值为 0.2
- **shadowOffset**: 弹窗的阴影偏移，默认值为(0, 2)
- **shadowRadius**: 弹窗的阴影半径，默认值为 8
- **backgroundColor**: 弹窗的背景颜色，默认值为白色
- **backgroundOpacity**: 背景遮罩的透明度，默认值为 0.5
- **allowTapOutsideToDismiss**: 是否允许点击外部区域关闭弹窗，默认值为 true
- **minHeight**: 当内容视图没有指定高度时的最小高度，默认值为 300
- **horizontalPadding**: 当内容视图没有指定宽度时的左右边距，默认值为 20
- **maxWidth**: 弹窗的最大宽度，默认值为 400
- **maxHeightRatio**: 弹窗的最大高度与屏幕高度的比例，默认值为 0.8
- **showCloseButton**: 是否在底部显示关闭按钮，默认值为 false
- **closeButtonText**: 关闭按钮显示的文本，默认值为"关闭"
- **closeButtonTextColor**: 关闭按钮文本颜色，默认值为白色
- **closeButtonBackgroundColor**: 关闭按钮背景颜色，默认值为系统蓝色

### 使用默认配置

```swift
// 使用默认配置
let config = ChimpionAlertConfig.default
```

### 部分自定义配置

您可以只自定义部分属性，其余使用默认值：

```swift
// 只自定义部分属性
let config = ChimpionAlertConfig(
    cornerRadius: 16,            // 只修改圆角
    backgroundColor: .systemGray5, // 只修改背景颜色
    allowTapOutsideToDismiss: false, // 只修改点击行为
        showCloseButton: true,           // 显示底部关闭按钮
        closeButtonText: "关闭弹窗",     // 自定义按钮文本
        closeButtonTextColor: .white,    // 自定义按钮文字颜色
        closeButtonBackgroundColor: .systemRed // 自定义按钮背景颜色
)
```

## 高级用法

### 动态更新内容视图

如果需要在显示后动态更新内容视图的大小，可以调用`updateLayout()`方法：

```swift
// 更新内容视图的约束
someConstraint.constant = 250

// 调用更新布局方法
alertController.updateLayout()
```

### 不指定宽高的内容视图

如果内容视图没有明确的宽高约束，弹窗会自动计算合适的尺寸：

```swift
let dynamicView = UIView()
dynamicView.backgroundColor = .white

// 添加一些子视图（无需设置dynamicView的宽高约束）
let label = UILabel()
label.text = "这是一个没有指定宽高的内容视图，弹窗会自动计算合适的尺寸。"
label.numberOfLines = 0
label.translatesAutoresizingMaskIntoConstraints = false
dynamicView.addSubview(label)

// 只需设置子视图的约束
NSLayoutConstraint.activate([
    label.topAnchor.constraint(equalTo: dynamicView.topAnchor, constant: 20),
    label.leadingAnchor.constraint(equalTo: dynamicView.leadingAnchor, constant: 20),
    label.trailingAnchor.constraint(equalTo: dynamicView.trailingAnchor, constant: -20),
    label.bottomAnchor.constraint(equalTo: dynamicView.bottomAnchor, constant: -20)
])

// 显示弹窗（弹窗会距离左右边距20，高度至少300）
self.showChimpionAlert(contentView: dynamicView)
```

### 禁用点击外部关闭

如果不想允许用户点击外部关闭弹窗：

```swift
// 方法1：通过配置对象
let config = ChimpionAlertConfig(allowTapOutsideToDismiss: false)
let alertController = ChimpionCustomAlertController(contentView: customView, config: config)

// 方法2：通过兼容API
let alertController = self.showChimpionAlert(contentView: customView, allowTapOutsideToDismiss: false)
```

### 自定义弹窗外观的完整示例

```swift
// 创建自定义内容视图
let contentView = UIView()
contentView.backgroundColor = .white

// 添加内容...

// 创建自定义配置，实现独特的弹窗样式
    let customConfig = ChimpionAlertConfig(
        cornerRadius: 24,              // 更大的圆角
        shadowColor: .black,           // 黑色阴影
        shadowOpacity: 0.4,            // 更明显的阴影
        shadowOffset: CGSize(width: 0, height: 8), // 更大的阴影偏移
        shadowRadius: 16,              // 更大的阴影模糊半径
        backgroundColor: .white,       // 白色背景
        backgroundOpacity: 0.6,        // 半透明黑色背景遮罩
        allowTapOutsideToDismiss: true, // 允许点击外部关闭
        minHeight: 350,                // 最小高度350
        horizontalPadding: 24,         // 左右边距24
        maxWidth: 420,                 // 最大宽度420
        maxHeightRatio: 0.85,          // 最大高度为屏幕的85%
        showCloseButton: true,         // 显示底部关闭按钮
        closeButtonText: "完成",       // 自定义按钮文本为"完成"
        closeButtonTextColor: .white,  // 按钮文本为白色
        closeButtonBackgroundColor: .systemGreen // 按钮背景为绿色
    )

// 显示自定义样式的弹窗
let alertController = ChimpionCustomAlertController(contentView: contentView, config: customConfig)
alertController.show(in: self)
```

## 示例代码

### 示例 1：简单的消息弹窗

```swift
func showMessageAlert(title: String, message: String) {
    // 创建内容视图
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false

    // 添加标题标签
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(titleLabel)

    // 添加消息标签
    let messageLabel = UILabel()
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(messageLabel)

    // 添加确定按钮
    let okButton = UIButton(type: .system)
    okButton.setTitle("确定", for: .normal)
    okButton.backgroundColor = .systemBlue
    okButton.setTitleColor(.white, for: .normal)
    okButton.layer.cornerRadius = 8
    okButton.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(okButton)

    // 设置约束
    NSLayoutConstraint.activate([
        // 内容视图尺寸约束（可选）
        contentView.widthAnchor.constraint(equalToConstant: 300),

        // 子视图约束
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

        okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
        okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        okButton.widthAnchor.constraint(equalToConstant: 100),
        okButton.heightAnchor.constraint(equalToConstant: 40),
        okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    ])

    // 显示弹窗（使用自定义配置）
    let config = ChimpionAlertConfig(
        cornerRadius: 16,                 // 圆角16
        backgroundColor: .white,          // 白色背景
        allowTapOutsideToDismiss: true,   // 允许点击外部关闭
        minHeight: 200,                   // 最小高度200
        horizontalPadding: 20,            // 左右边距20
        maxWidth: 350,                    // 最大宽度350
        showCloseButton: true,            // 显示底部关闭按钮
        closeButtonTextColor: .black,     // 文字颜色为黑色
        closeButtonBackgroundColor: .systemYellow // 背景为黄色
    )

    let alertController = self.showChimpionAlert(contentView: contentView, config: config)

    // 设置按钮点击事件
    okButton.addTarget(self, action: #selector(okButtonTapped(_:)), for: .touchUpInside)
    okButton.tag = alertController.hash
}

@objc func okButtonTapped(_ sender: UIButton) {
    // 查找对应的弹窗控制器并关闭
    if let alertController = self.presentedViewController as? ChimpionCustomAlertController {
        alertController.dismissAlert()
    }
}
```

### 示例 2：带输入框的弹窗

```swift
func showInputAlert() {
    // 创建内容视图
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false

    // 添加标题
    let titleLabel = UILabel()
    titleLabel.text = "输入信息"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(titleLabel)

    // 添加输入框
    let textField = UITextField()
    textField.placeholder = "请输入..."
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(textField)

    // 添加按钮容器
    let buttonStackView = UIStackView()
    buttonStackView.axis = .horizontal
    buttonStackView.spacing = 12
    buttonStackView.distribution = .fillEqually
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(buttonStackView)

    // 添加取消按钮
    let cancelButton = UIButton(type: .system)
    cancelButton.setTitle("取消", for: .normal)
    cancelButton.backgroundColor = .systemGray5
    cancelButton.setTitleColor(.black, for: .normal)
    cancelButton.layer.cornerRadius = 8
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    buttonStackView.addArrangedSubview(cancelButton)
    cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    // 添加确定按钮
    let confirmButton = UIButton(type: .system)
    confirmButton.setTitle("确定", for: .normal)
    confirmButton.backgroundColor = .systemBlue
    confirmButton.setTitleColor(.white, for: .normal)
    confirmButton.layer.cornerRadius = 8
    confirmButton.translatesAutoresizingMaskIntoConstraints = false
    buttonStackView.addArrangedSubview(confirmButton)
    confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    // 设置约束
    NSLayoutConstraint.activate([
        // 内容视图尺寸约束
        contentView.widthAnchor.constraint(equalToConstant: 300),

        // 子视图约束
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        textField.heightAnchor.constraint(equalToConstant: 44),

        buttonStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
        buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    ])

    // 显示弹窗
    let alertController = self.showChimpionAlert(contentView: contentView)

    // 设置按钮点击事件
    cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)

    // 保存对alertController的弱引用，避免循环引用
    cancelButton.tag = alertController.hash
    confirmButton.tag = alertController.hash

    // 保存对textField的弱引用
    confirmButton.accessibilityIdentifier = "confirmButton"
    objc_setAssociatedObject(confirmButton, &AssociatedKeys.textFieldKey, textField, .OBJC_ASSOCIATION_RETAIN)
}

// 用于关联对象的key
private struct AssociatedKeys {
    static var textFieldKey = "textFieldKey"
}

@objc func cancelButtonTapped(_ sender: UIButton) {
    // 关闭弹窗
    if let alertController = self.presentedViewController as? ChimpionCustomAlertController {
        alertController.dismissAlert()
    }
}

@objc func confirmButtonTapped(_ sender: UIButton) {
    // 获取输入框内容
    if let textField = objc_getAssociatedObject(sender, &AssociatedKeys.textFieldKey) as? UITextField {
        let inputText = textField.text ?? ""
        print("用户输入：", inputText)
        // 处理输入内容...
    }

    // 关闭弹窗
    if let alertController = self.presentedViewController as? ChimpionCustomAlertController {
        alertController.dismissAlert()
    }
}
```

## 注意事项

1. **视图尺寸处理**：

   - 如果内容视图有明确的宽高约束，弹窗会使用这些约束
   - 如果没有明确的宽高约束，弹窗会距离左右边距 20，高度最小 300
   - 弹窗会自动限制最大宽度不超过配置的 maxWidth，最大高度不超过屏幕高度的 maxHeightRatio

2. **内容视图约束**：

   - 确保内容视图的子视图都有正确的约束，以避免布局错误
   - 如果内容视图的大小在显示后需要改变，记得调用`updateLayout()`方法

3. **内存管理**：

   - 在内容视图的子视图中引用弹窗控制器时，建议使用弱引用避免循环引用
   - 弹窗控制器会在被关闭时自动释放

4. **iOS 版本支持**：

   - 建议在 iOS 15.0 及以上版本使用，以获得最佳体验

5. **交互处理**：

   - 如果关闭按钮需要引用弹窗控制器，请确保正确管理引用关系
   - 当弹窗显示时，背景视图会拦截触摸事件，但点击内容视图本身不会关闭弹窗

6. **圆角显示**：

   - 弹窗容器默认启用了裁剪功能（clipsToBounds = true），确保所有子视图都会被正确限制在圆角范围内
   - 这意味着即使内容视图本身没有设置圆角，也会被正确地显示在弹窗的圆角区域内
   - 如果您希望内容视图的某些部分超出圆角边界，请在自定义配置中调整相应设置

7. **底部关闭按钮**：
   - 可以通过设置`showCloseButton = true`来显示一个高度为 44，宽度与内容视图相同的底部关闭按钮
   - 关闭按钮默认使用系统蓝色背景和白色文字，点击后会关闭弹窗
   - 可以通过配置选项自定义按钮文本、文本颜色和背景颜色
   - 如果显示了关闭按钮，内容视图将位于按钮上方，不再延伸到底部
   - 示例：自定义按钮样式
   ```swift
   let config = ChimpionAlertConfig(
       showCloseButton: true,            // 显示关闭按钮
       closeButtonText: "确认",         // 自定义按钮文字为"确认"
       closeButtonTextColor: .white,     // 按钮文字颜色为白色
       closeButtonBackgroundColor: .systemOrange // 按钮背景为橙色
   )
   ```
