// 完整的路由测试

import Foundation

// 简化的RouterManager实现
class TestRouterManager {
    
    // MARK: - 属性
    private var routerRegistry: [String: () -> Bool] = [:]
    
    // MARK: - 注册方法
    public func register(path: String, handler: @escaping () -> Bool) {
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        routerRegistry[normalizedPath] = handler
        print("注册路由: \(normalizedPath)")
    }
    
    // MARK: - 路由方法
    @discardableResult
    public func route(to uri: String) -> Bool {
        // 解析URI
        guard let (scheme, path, parameters) = parseURI(uri) else {
            print("URI解析失败: \(uri)")
            return false
        }
        
        print("URI解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("Parameters: \(parameters)")
        
        // 查找匹配的路由处理闭包
        for (registeredPath, handler) in routerRegistry {
            print("\n尝试匹配路由:")
            print("注册路径: \(registeredPath)")
            print("请求路径: \(path)")
            
            var matchParams: [String: Any] = parameters
            if matchPath(registeredPath: registeredPath, requestPath: path, parameters: &matchParams) {
                print("路径匹配成功!")
                return handler()
            } else {
                print("路径匹配失败!")
            }
        }
        
        print("未找到匹配的路由")
        return false
    }
    
    // MARK: - 私有方法
    private func parseURI(_ uri: String) -> (scheme: String, path: String, parameters: [String: Any])? {
        guard let urlComponents = URLComponents(string: uri) else {
            return nil
        }
        
        guard let scheme = urlComponents.scheme else {
            return nil
        }
        
        guard let path = urlComponents.path.isEmpty ? nil : urlComponents.path else {
            return nil
        }
        
        var parameters: [String: Any] = [:]
        
        // 解析查询参数
        if let queryItems = urlComponents.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        return (scheme, path, parameters)
    }
    
    private func matchPath(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
        // 将路径拆分为组件
        let registeredComponents = registeredPath.components(separatedBy: "/")
        let requestComponents = requestPath.components(separatedBy: "/")
        
        print("注册路径组件: \(registeredComponents)")
        print("请求路径组件: \(requestComponents)")
        
        // 路径组件数量必须相同
        if registeredComponents.count != requestComponents.count {
            return false
        }
        
        // 逐个比较路径组件
        for (index, registeredComponent) in registeredComponents.enumerated() {
            let requestComponent = requestComponents[index]
            
            // 如果是路径参数（以:开头），则将其添加到参数字典中
            if registeredComponent.hasPrefix(":") {
                let parameterName = String(registeredComponent.dropFirst())
                parameters[parameterName] = requestComponent
                print("解析路径参数: \(parameterName) = \(requestComponent)")
            } else if registeredComponent != requestComponent {
                // 如果不是路径参数且不匹配，则返回false
                return false
            }
        }
        
        return true
    }
}

// 运行完整测试
print("=== 完整路由测试 ===")

let router = TestRouterManager()

// 注册路由
router.register(path: "detail/:id") { () -> Bool in
    print("执行detail路由处理器")
    return true
}

// 测试路由匹配
print("\n=== 测试URI路由匹配 ===")
let result = router.route(to: "myapp://detail/123")
print("\n路由执行结果: \(result)")

// 测试另一个URI
print("\n=== 测试另一个URI路由匹配 ===")
let result2 = router.route(to: "myapp://detail/456?name=test")
print("\n路由执行结果: \(result2)")

print("\n=== 测试结束 ===")