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
pod 'MyToolLibrary', :git => 'https://github.com/basszhx3x/MyToolLibrary.git'
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

- iOS 12.0+
- Swift 5.0+

## 许可证

MyToolLibrary 使用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 贡献

欢迎提交 Issue 和 Pull Request！
