# RouterManager 使用说明

## 概述
RouterManager 是一个强大的路由管理器，用于在 iOS 应用中实现页面间的导航和参数传递。它支持 URI 解析、路由注册和路由执行等功能，使页面跳转更加灵活和统一。

## 核心功能

1. **URI 解析**：支持解析包含 scheme、path 和 query parameters 的 URI
2. **路由注册**：支持注册静态路径和带参数的路径
3. **路由执行**：支持根据 URI 执行对应的页面跳转
4. **默认路由**：支持设置未匹配路由时的默认处理逻辑
5. **类型安全的路由注册**：提供类型安全的 API 进行路由注册

## 使用方法

### 1. 导入模块

```swift
import ChimpionTools
```

### 2. 路由注册

#### 2.1 基础路由注册

```swift
// 注册首页路由
RouterManager.shared.register(path: "home") { (vc, params) in
    let destinationVC = HomeViewController()
    vc.navigationController?.pushViewController(destinationVC, animated: true)
    return true
}

// 注册带参数的详情页路由
RouterManager.shared.register(path: "detail/:id") { (vc, params) in
    let destinationVC = DetailViewController()
    if let id = params["id"] as? String {
        destinationVC.productId = id
    }
    vc.navigationController?.pushViewController(destinationVC, animated: true)
    return true
}
```

#### 2.2 类型安全的路由注册

```swift
// 使用类型安全的 API 注册路由
RouterManager.shared.register(path: "profile/:userId") { params -> ProfileViewController? in
    let profileVC = ProfileViewController()
    if let userId = params["userId"] as? String {
        profileVC.userId = userId
    }
    return profileVC
}

// 自定义展示方式
RouterManager.shared.register(path: "settings", builder: { params -> SettingsViewController? in
    return SettingsViewController()
}, presentationStyle: .modal(presentationStyle: .formSheet, transitionStyle: .coverVertical))
```

### 3. 路由执行

```swift
// 执行首页路由
RouterManager.shared.route(to: "myapp://home")

// 执行带参数的详情页路由
RouterManager.shared.route(to: "myapp://detail/123?name=测试产品&price=99.9")

// 执行复杂参数路由
RouterManager.shared.route(to: "myapp://product/456/info?category=electronics&brand=Apple")

// 从指定视图控制器执行路由
RouterManager.shared.route(to: "myapp://settings", from: self)
```

### 4. 设置默认路由

```swift
// 设置默认路由处理器
RouterManager.shared.registerDefault { (vc, params) in
    let alert = UIAlertController(title: "路由错误", message: "未找到匹配的路由", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
    return true
}
```

### 5. 清理路由注册

```swift
// 清理所有路由注册
RouterManager.shared.clearRoutes()
```

## 展示方式

RouterManager 支持三种展示方式：

1. **push**：使用导航控制器进行页面 push
2. **present**：直接 present 页面
3. **modal**：模态展示（可以自定义模态展示样式和转场样式）

```swift
// push 方式（默认）
RouterManager.shared.register(path: "home", builder: { _ in HomeViewController() })

// present 方式
RouterManager.shared.register(path: "modal", builder: { _ in ModalViewController() }, presentationStyle: .present)

// 自定义模态样式
RouterManager.shared.register(
    path: "customModal", 
    builder: { _ in CustomModalViewController() }, 
    presentationStyle: .modal(
        presentationStyle: .pageSheet, 
        transitionStyle: .crossDissolve
    )
)
```

## URI 格式

RouterManager 支持的 URI 格式为：

```
scheme://path?key1=value1&key2=value2
```

- **scheme**：应用的 scheme，用于区分不同应用
- **path**：路由路径，可以是静态路径（如 "home"）或带参数的路径（如 "detail/:id"）
- **query parameters**：查询参数，使用键值对形式传递

## 测试页面

在 `RouterManagerTestViewController` 中，您可以测试以下路由功能：

1. **首页路由**：测试静态路径路由
2. **详情页路由**：测试带参数的路径路由
3. **复杂参数路由**：测试多级路径和多个参数的路由
4. **模态路由**：测试模态展示的路由
5. **自定义 URI**：测试自定义 URI 的路由功能

## 注意事项

1. 注册路由时，路径会自动进行标准化处理，确保格式一致
2. 路径参数使用 `:paramName` 格式定义
3. 路由执行时，未匹配到路由会调用默认路由处理器
4. 建议在应用启动时注册所有路由
5. 在测试环境中，可以使用 `clearRoutes()` 方法清理路由注册

## 示例代码

```swift
// 应用启动时注册路由
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 注册路由
    RouterManager.shared.register(path: "home") { (vc, params) in
        let homeVC = HomeViewController()
        vc.navigationController?.pushViewController(homeVC, animated: true)
        return true
    }
    
    RouterManager.shared.register(path: "detail/:id") { (vc, params) in
        let detailVC = DetailViewController()
        if let id = params["id"] as? String {
            detailVC.itemId = id
        }
        vc.navigationController?.pushViewController(detailVC, animated: true)
        return true
    }
    
    // 设置默认路由
    RouterManager.shared.registerDefault { (vc, params) in
        let alert = UIAlertController(title: "路由错误", message: "未找到匹配的路由", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        return true
    }
    
    return true
}

// 在任意页面执行路由
@IBAction func goToDetail(_ sender: UIButton) {
    RouterManager.shared.route(to: "myapp://detail/789?name=示例产品", from: self)
}
```