# MyToolLibrary

一个功能丰富的 iOS 开发工具库，提供各种实用的扩展和工具类，帮助开发者提高开发效率。

## 功能特点

### 集合扩展

- **Array 扩展**：提供安全访问、数组分块、去重、元素检查等功能
- **Dictionary 扩展**：提供安全访问、字典合并、URL 查询字符串转换等功能

### 数据处理

- **DataConverter**：JSON 与 Data 转换、数据序列化和反序列化
- **DataValidator**：数据验证、大小检查、模式匹配
- **DataOperations**：数据合并、分割、范围提取

### 字符串处理

- **String 扩展**：截断、哈希计算（MD5/SHA256）、Base64 编解码、安全访问、字符串转布尔值等
- **StringParser**：数字提取、URL 提取、HTML 文本提取、JSON 解析
- **NSAttributedString 扩展**：便捷构造方法、链式调用、文本样式设置、文本高亮等功能

### 时间处理

- **DateTimeHelper**：日期计算、时间间隔添加（年、月、日、小时、分钟、秒）

### 安全存储

- **KeychainHelper**：基于 KeychainSwift 的安全数据存储、读取和删除

### 日志工具

- **IgatherFileLogger**：按日期记录日志到文件，支持多种日志级别

### UI 扩展

- **UIView 扩展**：圆角、边框、阴影添加，便捷视图创建
- **UIImage 扩展**：资源图片加载
- **UIWindow 扩展**：获取当前 keyWindow

### 打印扩展

- **printLog**：带时间戳的调试打印函数，仅在 DEBUG 模式下输出

### 自定义视图

- **ChimpionAlertController**：自定义弹窗控制器
- **ChimpionButton**：基于 iOS 15.0+ 的高度可定制按钮组件，支持多种图标布局方式、图片尺寸限制和内容配置
- **ChimpionNavigationBar**：模仿 iOS 原生导航栏的自定义组件，支持标题、左右两侧按钮和自定义视图配置
- **ChimpionCustomAlertController**：可显示任意自定义视图的 Alert 控制器，智能处理尺寸布局，支持点击外部关闭
- **ChimpionRadioButton**：基于 iOS 15.0+ 的高度可定制单选按钮组件，支持自定义颜色、图标、尺寸等，提供单选按钮组管理功能

## 安装方式

### CocoaPods

在您的 Podfile 中添加：

```ruby
pod 'ChimpionTools', :path => '/path/to/MyToolLibrary'
```

然后执行：

```bash
pod install
```

## 使用示例

### 集合扩展

```swift
// Array安全访问
let array = [1, 2, 3]
let element = array[safe: 5] // nil，不会崩溃

// 数组分块
let chunkedArray = array.chunked(into: 2) // [[1, 2], [3]]

// Dictionary合并
var dict1 = ["a": 1]
let dict2 = ["b": 2]
dict1.merge(with: dict2) // ["a": 1, "b": 2]
```

### 字符串处理

```swift
// 字符串截断
let longString = "This is a very long string"
let truncated = longString.truncated(to: 10) // "This is..."

// MD5哈希
let hash = "password123".md5

// JSON解析
if let dict = StringParser.parseJSONStringToDictionary(jsonString) {
    // 处理解析后的字典
}

// 字符串转布尔值
let trueString = "true"
let boolValue = trueString.boolValue // true
let falseString = "0"
let boolValue2 = falseString.boolValue // false
let unknownString = "unknown"
let boolValue3 = unknownString.boolValue // nil
let boolWithDefault = unknownString.toBool(defaultValue: false) // false

// NSAttributedString 便捷构造
let attributedString = NSAttributedString(string: "Hello World",
                                         font: .systemFont(ofSize: 18),
                                         color: .systemBlue)

// 链式调用设置样式
let styledString = NSAttributedString(string: "Styled Text")
    .withFont(.boldSystemFont(ofSize: 20))
    .withColor(.red)
    .withUnderline()

// NSMutableAttributedString 应用样式
let mutableString = NSMutableAttributedString(string: "Hello World")
mutableString.applyingAttributes([.font: UIFont.boldSystemFont(ofSize: 16)],
                               range: NSRange(location: 0, length: 5))

// 文本高亮
let text = "Highlight this word"
let highlighted = NSMutableAttributedString(string: text)
highlighted.highlightSubstring("this",
                              withColor: .yellow,
                              backgroundColor: .orange)
```

### 数据转换

```swift
// 模型转JSON
let data = DataConverter.toData(myModel)

// JSON转模型
if let model = DataConverter.fromData(data, type: MyModel.self) {
    // 处理转换后的模型
}
```

### 安全存储

```swift
// 保存数据到Keychain
KeychainHelper.save(key: "userToken", value: "myToken123")

// 读取数据
if let token = KeychainHelper.getValue(key: "userToken") {
    // 使用token
}

// 删除数据
KeychainHelper.delete(key: "userToken")
```

### 日志记录

```swift
// 记录日志
IgatherFileLogger.shared.log(level: .info, message: "应用启动成功")
IgatherFileLogger.shared.log(level: .error, message: "网络请求失败")
```

### UI 扩展

```swift
// 给视图添加圆角
myView.addCornerRadius(8)

// 添加阴影
myView.addShadow(color: .gray, opacity: 0.3, radius: 4)

// 便捷创建视图
let button: UIButton = .build {
    $0.setTitle("点击我", for: .normal)
    $0.backgroundColor = .systemBlue
}

// 加载资源图片
let image = BundleImage.loadImage(named: "myImage")
```

### ChimpionButton 组件使用

```swift
// 创建并配置按钮
let button = ChimpionButton(frame: CGRect(x: 50, y: 100, width: 200, height: 50))
button.setTitle("添加到购物车", for: .normal)
button.setTitleColor(.white, for: .normal)
button.setImage(UIImage(named: "cart"), for: .normal)
button.backgroundColor = .systemBlue
button.layer.cornerRadius = 25

// 设置图标位置
button.imagePosition = .left  // 图标在左侧
// button.imagePosition = .right  // 图标在右侧
// button.imagePosition = .top    // 图标在上方
// button.imagePosition = .bottom // 图标在下方

// 设置间距和图片尺寸
button.spacing = 12
button.maxImageSize = CGSize(width: 24, height: 24)

// 使用便捷方法一次性配置
button.set(
    title: "提交",
    image: UIImage(named: "submit"),
    position: .left,
    spacing: 12,
    maxImageSize: CGSize(width: 24, height: 24)
)
```

### ChimpionNavigationBar 组件使用

```swift
// 创建导航栏
let navigationBar = ChimpionNavigationBar()
navigationBar.translatesAutoresizingMaskIntoConstraints = false
navigationBar.title = "页面标题"
navigationBar.barBackgroundColor = .white

// 设置返回按钮
navigationBar.setBackButton(target: self, action: #selector(backButtonTapped))

// 设置右侧按钮
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

### ChimpionRadioButton 组件使用

```swift
// 创建单个单选按钮
let radioButton = ChimpionRadioButton()
radioButton.setTitle("选项 1", for: .normal)

// 使用RadioConfig配置单选按钮
let customConfig = RadioConfig(
    selectedColor: .systemGreen,
    unselectedColor: .lightGray,
    buttonSize: 24,
    borderWidth: 2,
    titleFont: .systemFont(ofSize: 16),
    selectedTextColor: .systemGreen,
    unselectedTextColor: .systemGray,
    titlePadding: 10
)
radioButton.radioConfig = customConfig

// 添加到视图
view.addSubview(radioButton)

// 创建单选按钮组
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

### ChimpionCustomAlertController 组件使用

```swift
// 创建自定义内容视图
let customView = UIView()
customView.translatesAutoresizingMaskIntoConstraints = false

// 添加标题标签
let titleLabel = UILabel()
titleLabel.text = "自定义弹窗"
titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
titleLabel.translatesAutoresizingMaskIntoConstraints = false
customView.addSubview(titleLabel)

// 添加关闭按钮
let closeButton = UIButton(type: .system)
closeButton.setTitle("关闭", for: .normal)
closeButton.backgroundColor = .systemBlue
closeButton.setTitleColor(.white, for: .normal)
closeButton.layer.cornerRadius = 8
closeButton.translatesAutoresizingMaskIntoConstraints = false
customView.addSubview(closeButton)

// 设置约束
NSLayoutConstraint.activate([
    // 内容视图尺寸约束
    customView.widthAnchor.constraint(equalToConstant: 300),
    customView.heightAnchor.constraint(equalToConstant: 200),

    // 子视图约束
    titleLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
    titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 30),

    closeButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
    closeButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -30),
    closeButton.widthAnchor.constraint(equalToConstant: 100),
    closeButton.heightAnchor.constraint(equalToConstant: 40)
])

// 方式1：直接创建并显示
let alertController = ChimpionCustomAlertController(contentView: customView)
alertController.allowTapOutsideToDismiss = true
alertController.show(in: self)

// 方式2：使用便捷扩展方法
// let alertController = self.showChimpionAlert(contentView: customView)

// 为关闭按钮添加点击事件
closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)

@objc func closeAlert() {
    // 关闭弹窗
    if let alertController = self.presentedViewController as? ChimpionCustomAlertController {
        alertController.dismissAlert()
    }
}
```

## 注意事项

1. 使用 KeychainHelper 时，请确保已在 Podfile 中添加 KeychainSwift 依赖
2. 在 iOS 15 及以上版本使用 pod 时，如遇到 Sandbox 相关错误，可尝试修改 User Script Sandboxing 设置为 NO
3. 日志文件默认保存在应用的 Documents/Logs 目录下，按日期命名
4. ChimpionButton、ChimpionNavigationBar 和 ChimpionRadioButton 组件要求 iOS 15.0 或更高版本，其中 ChimpionButton 基于 UIButtonConfiguration API 构建

## 许可证

[MIT License](LICENSE)

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
