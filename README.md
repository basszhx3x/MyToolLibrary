# MyToolLibrary

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

一个实用的 Swift 工具库，包含各种常用的扩展和工具类。

## 功能特性

- 📱 **UIKit 扩展** - UIView、UIColor 等常用 UIKit 类的扩展
- 📅 **日期工具** - 日期格式化、相对时间计算等
- 🔤 **字符串工具** - 邮箱验证、手机号验证、字符串处理等
- 🌐 **网络工具** - 简化的网络请求封装
- 📊 **设备信息** - 获取设备型号、系统版本等信息

## 安装

### CocoaPods

在您的 Podfile 中添加：

```ruby
pod 'ChimpionTools', :git => 'https://github.com/basszhx3x/MyToolLibrary.git'
```

然后运行：

```bash
pod install
```

## 使用示例

### 字符串扩展

```swift
let email = "test@example.com"
print(email.isValidEmail) // true

let phone = "13812345678"
print(phone.isValidChinesePhone) // true
```

### 日期扩展

```swift
let date = Date()
print(date.toString()) // "2024-01-01 12:00:00"
print(date.relativeTime) // "刚刚"
```

### UIView 扩展

```swift
let view = UIView()
view.addCornerRadius(8)
view.addShadow()
```

## 要求

- iOS 15.0+
- Swift 5.0+

## 许可证

ChimpionTools 使用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 贡献

欢迎提交 Issue 和 Pull Request！

version 1.2.1

# MyToolLibrary

一个功能丰富的 Swift 工具库，为 iOS/macOS 开发提供便捷的扩展和实用工具。

## 📦 功能特性

### 🔧 扩展功能 (Extensions)
- **UIView+Extensions**: 视图样式扩展（圆角、边框、阴影等）
- **UIWindow+Extension**: 窗口管理工具
- **UIImage+Extension**: 图片加载和资源管理
- **Date+Extensions**: 日期时间处理和格式化
- **String+Extensions**: 字符串验证和格式化
- **Device+Extension**: 设备信息和安全区域获取
- **Print+Extensions**: 调试日志增强

### 🛠️ 实用工具 (Utilities)
- **ChimpQRCodeGenerator**: 二维码生成器
- **ChimpFileLog**: 文件日志系统
- **DataObservable**: 数据观察者模式实现
- **KeychainHelper**: Keychain 安全存储
- **NetworkManager**: 网络请求管理
- **DeviceInfo**: 设备信息获取

## 🚀 安装方式

### Swift Package Manager

在 `Package.swift` 文件中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/MyToolLibrary.git", from: "1.2.1")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'MyToolLibrary', '~> 1.2.1'
```

## 📚 使用示例

### 视图样式设置
```swift
let view = UIView()
view.addCornerRadius(10)
view.addBorder(width: 1, color: .blue)
view.addShadow(color: .black, opacity: 0.3, offset: CGSize(width: 0, height: 2), radius: 4)
```

### 二维码生成
```swift
let generator = ChimpQRCodeGenerator()
if let qrImage = generator.generateQRCode(
    from: "https://example.com",
    size: CGSize(width: 300, height: 300),
    color: .blue,
    backgroundColor: .white
) {
    imageView.image = qrImage
}
```

### 文件日志
```swift
// 记录不同级别的日志
FileLogger.shared.log("应用启动", level: .info)
FileLogger.shared.log("用户登录成功", level: .debug)
FileLogger.shared.log("网络请求超时", level: .warning)

// 清理旧日志
if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
    FileLogger.shared.cleanLogs(before: sevenDaysAgo)
}
```

### Keychain 存储
```swift
// 保存数据
KeychainHelper.save(key: "user_token", value: "abc123")

// 读取数据
if let token = KeychainHelper.getValue(key: "user_token") {
    print("用户令牌: \(token)")
}

// 删除数据
KeychainHelper.delete(key: "user_token")
```

### 数据观察者
```swift
class UserViewModel {
    let userName = ChimpObservable("")
    
    func updateName() {
        userName.value = "新用户名"
    }
}

// 观察数据变化
let viewModel = UserViewModel()
viewModel.userName.observe { newName in
    print("用户名更新为: \(newName)")
}
```
