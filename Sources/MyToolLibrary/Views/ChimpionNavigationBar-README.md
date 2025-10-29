# ChimpionNavigationBar 使用指南

## 简介

`ChimpionNavigationBar` 是一个高度可定制的导航栏组件，模仿iOS原生NavigationBar的外观和行为。它提供了灵活的配置选项，支持自定义标题、左右两侧按钮、背景颜色、底部分隔线等元素，适用于需要自定义导航体验的iOS应用。

## 特性

- 支持自定义标题文本、字体和颜色
- 可配置左侧按钮（如返回按钮）
- 支持单个或多个右侧按钮
- 允许使用自定义视图作为标题
- 可定制背景颜色和底部分隔线
- 自动处理标题与按钮的布局，防止重叠
- 支持内容边距调整
- 基于iOS 15.0+的UIKit最佳实践构建

## 快速开始

### 1. 导入库

在需要使用的文件中导入：

```swift
import MyToolLibrary
```

### 2. 创建导航栏

```swift
// 使用代码创建
let navigationBar = ChimpionNavigationBar()
navigationBar.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(navigationBar)

// 设置约束
NSLayoutConstraint.activate([
    navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
])
```

## 基本配置

### 设置标题

```swift
// 设置标题文本
navigationBar.title = "页面标题"

// 设置标题字体
navigationBar.titleFont = UIFont.boldSystemFont(ofSize: 18)

// 设置标题颜色
navigationBar.titleColor = .systemBlue
```

### 设置返回按钮

```swift
// 设置标准返回按钮
navigationBar.setBackButton(target: self, action: #selector(backButtonTapped))

// 按钮点击处理方法
@objc func backButtonTapped() {
    print("返回按钮点击")
    // 执行返回操作
}
```

### 设置自定义左侧按钮

```swift
// 创建自定义按钮
let customLeftButton = UIButton(type: .system)
customLeftButton.setTitle("菜单", for: .normal)
customLeftButton.setTitleColor(.systemGreen, for: .normal)

// 设置按钮
navigationBar.setLeftButton(customLeftButton, target: self, action: #selector(menuButtonTapped))
```

### 设置右侧按钮

```swift
// 创建右侧按钮
let rightButton = UIButton(type: .system)
rightButton.setTitle("完成", for: .normal)
rightButton.setTitleColor(.systemBlue, for: .normal)

// 设置右侧按钮
navigationBar.setRightButton(rightButton, target: self, action: #selector(doneButtonTapped))
```

### 设置多个右侧按钮

```swift
// 创建多个按钮
let shareButton = UIButton(type: .system)
shareButton.setTitle("分享", for: .normal)
shareButton.setTitleColor(.systemBlue, for: .normal)

let moreButton = UIButton(type: .system)
moreButton.setTitle("更多", for: .normal)
moreButton.setTitleColor(.systemBlue, for: .normal)

// 设置多个右侧按钮
navigationBar.setRightButtons([moreButton, shareButton], target: self, action: #selector(rightButtonTapped(_:)))

// 处理多个按钮的点击（通过tag区分）
@objc func rightButtonTapped(_ sender: UIButton) {
    switch sender.tag {
    case 0:
        print("更多按钮点击")
    case 1:
        print("分享按钮点击")
    default:
        break
    }
}
```

### 设置自定义标题视图

```swift
// 创建自定义标题视图
let titleStackView = UIStackView()
titleStackView.axis = .horizontal
titleStackView.alignment = .center
titleStackView.spacing = 8

// 添加图片和标签
let iconImageView = UIImageView(image: UIImage(systemName: "star.fill"))
iconImageView.tintColor = .systemYellow

let titleLabel = UILabel()
titleLabel.text = "自定义标题"
titleLabel.font = UIFont.boldSystemFont(ofSize: 17)

titleStackView.addArrangedSubview(iconImageView)
titleStackView.addArrangedSubview(titleLabel)

// 设置自定义标题视图
navigationBar.setTitleView(titleStackView)
```

## 外观定制

### 背景和边框

```swift
// 设置背景色
navigationBar.barBackgroundColor = .white

// 显示/隐藏底部分隔线
navigationBar.showsBottomBorder = true

// 设置底部分隔线颜色
navigationBar.bottomBorderColor = UIColor.systemGray.withAlphaComponent(0.5)
```

### 内容边距调整

```swift
// 设置左侧内容边距
navigationBar.leftContentInset = 20

// 设置右侧内容边距
navigationBar.rightContentInset = 20
```

## 重置导航栏

```swift
// 重置导航栏到初始状态
navigationBar.reset()
```

## 示例代码

### 基本导航栏示例

```swift
// 创建并配置基本导航栏
let navigationBar = ChimpionNavigationBar()
navigationBar.translatesAutoresizingMaskIntoConstraints = false
navigationBar.title = "首页"
navigationBar.titleColor = .black
navigationBar.barBackgroundColor = .white
navigationBar.setBackButton(target: self, action: #selector(backButtonTapped))

// 添加右侧完成按钮
let doneButton = UIButton(type: .system)
doneButton.setTitle("完成", for: .normal)
doneButton.setTitleColor(.systemBlue, for: .normal)
navigationBar.setRightButton(doneButton, target: self, action: #selector(doneButtonTapped))

// 添加到视图并设置约束
view.addSubview(navigationBar)
NSLayoutConstraint.activate([
    navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
])
```

### 带自定义标题的导航栏

```swift
// 创建导航栏
let navigationBar = ChimpionNavigationBar()
navigationBar.translatesAutoresizingMaskIntoConstraints = false
navigationBar.barBackgroundColor = .systemBackground

// 创建自定义标题视图
let titleContainer = UIView()
let titleLabel = UILabel()
titleLabel.text = "搜索"
titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
titleLabel.translatesAutoresizingMaskIntoConstraints = false

titleContainer.addSubview(titleLabel)
NSLayoutConstraint.activate([
    titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
    titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
    titleContainer.heightAnchor.constraint(equalToConstant: 44)
])

// 设置自定义标题视图
navigationBar.setTitleView(titleContainer)

// 设置搜索按钮
let searchButton = UIButton(type: .system)
searchButton.setTitle("搜索", for: .normal)
searchButton.setTitleColor(.systemBlue, for: .normal)
navigationBar.setRightButton(searchButton, target: self, action: #selector(searchButtonTapped))

// 添加到视图
view.addSubview(navigationBar)
NSLayoutConstraint.activate([
    navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
])
```

### 带多个右侧按钮的导航栏

```swift
// 创建导航栏
let navigationBar = ChimpionNavigationBar()
navigationBar.translatesAutoresizingMaskIntoConstraints = false
navigationBar.title = "编辑"
navigationBar.barBackgroundColor = .white

// 创建返回按钮
navigationBar.setBackButton(target: self, action: #selector(cancelEdit))

// 创建多个右侧按钮
let saveButton = UIButton(type: .system)
saveButton.setTitle("保存", for: .normal)
saveButton.setTitleColor(.systemBlue, for: .normal)
\let deleteButton = UIButton(type: .system)
deleteButton.setTitle("删除", for: .normal)
deleteButton.setTitleColor(.systemRed, for: .normal)

// 设置多个右侧按钮
navigationBar.setRightButtons([deleteButton, saveButton], target: self, action: #selector(rightButtonAction(_:)))

// 添加到视图
view.addSubview(navigationBar)
NSLayoutConstraint.activate([
    navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
])

// 处理右侧按钮点击
@objc func rightButtonAction(_ sender: UIButton) {
    switch sender.tag {
    case 0:
        // 删除按钮（tag 0）
        confirmDelete()
    case 1:
        // 保存按钮（tag 1）
        saveChanges()
    default:
        break
    }
}
```

## 注意事项

1. **高度设置**：ChimpionNavigationBar默认高度为44，这是iOS标准导航栏的高度
2. **安全区域**：使用时请确保正确处理安全区域，特别是在iPhone X及以上设备上
3. **标题宽度限制**：导航栏会自动限制标题宽度，防止与两侧按钮重叠
4. **按钮布局**：当添加多个右侧按钮时，按钮会从右向左排列
5. **自定义视图**：使用自定义标题视图时，请注意控制其宽度，避免布局问题
6. **iOS版本要求**：建议在iOS 15.0及以上版本使用，以获得最佳体验
7. **响应式布局**：导航栏会根据内容自动调整布局，但在极端情况下可能需要手动调整约束
