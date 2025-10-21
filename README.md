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

- **String 扩展**：截断、哈希计算（MD5/SHA256）、Base64 编解码、安全访问等
- **StringParser**：数字提取、URL 提取、HTML 文本提取、JSON 解析

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

## 注意事项

1. 使用 KeychainHelper 时，请确保已在 Podfile 中添加 KeychainSwift 依赖
2. 在 iOS 15 及以上版本使用 pod 时，如遇到 Sandbox 相关错误，可尝试修改 User Script Sandboxing 设置为 NO
3. 日志文件默认保存在应用的 Documents/Logs 目录下，按日期命名

## 许可证

[MIT License](LICENSE)

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
