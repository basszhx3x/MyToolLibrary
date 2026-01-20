// 综合路由测试

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
        print("\n=== 测试路由: \(uri) ===")
        
        // 解析URI
        guard let (scheme, path, parameters) = parseURI(uri) else {
            print("URI解析失败")
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
                print("最终参数: \(matchParams)")
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
        // 移除URI中的scheme部分
        guard let schemeRange = uri.range(of: "://") else {
            return nil
        }
        
        let scheme = String(uri[..<schemeRange.lowerBound])
        let remainingString = String(uri[schemeRange.upperBound...])
        
        // 解析路径和查询参数
        var path: String
        var parameters: [String: Any] = [:]
        
        // 查找查询参数的开始位置
        if let queryStartIndex = remainingString.range(of: "?") {
            // 提取路径部分
            path = String(remainingString[..<queryStartIndex.lowerBound])
            
            // 提取并解析查询参数部分
            let queryString = String(remainingString[queryStartIndex.upperBound...])
            
            // 将查询参数拆分为键值对
            let queryComponents = queryString.components(separatedBy: "&")
            for component in queryComponents {
                let keyValue = component.components(separatedBy: "=")
                if keyValue.count == 2 {
                    let key = keyValue[0]
                    let value = keyValue[1].removingPercentEncoding ?? keyValue[1]
                    parameters[key] = value
                }
            }
        } else {
            // 没有查询参数，整个剩余部分都是路径
            path = remainingString
        }
        
        // 确保路径以斜杠开头
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        
        return (scheme, path, parameters)
    }
    
    private func matchPath(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
        // 清理路径，移除末尾的斜杠（根路径除外）
        func cleanPath(_ path: String) -> String {
            var cleanedPath = path
            // 如果路径不是根路径且末尾有斜杠，则移除末尾的斜杠
            if cleanedPath != "/" && cleanedPath.hasSuffix("/") {
                cleanedPath = String(cleanedPath.dropLast())
            }
            return cleanedPath
        }
        
        // 清理路径
        let cleanedRegisteredPath = cleanPath(registeredPath)
        let cleanedRequestPath = cleanPath(requestPath)
        
        print("清理后路径:")
        print("注册路径: \(cleanedRegisteredPath)")
        print("请求路径: \(cleanedRequestPath)")
        
        // 将路径拆分为组件
        let registeredComponents = cleanedRegisteredPath.components(separatedBy: "/")
        let requestComponents = cleanedRequestPath.components(separatedBy: "/")
        
        print("路径组件:")
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

// 运行综合测试
print("=== 综合路由测试 ===")

let router = TestRouterManager()

// 注册路由
router.register(path: "home") { 
    print("执行home路由处理器")
    return true
}

router.register(path: "detail/:id") { 
    print("执行detail路由处理器")
    return true
}

router.register(path: "product/:productId/info") { 
    print("执行product路由处理器")
    return true
}

// 测试用例
let testURIs = [
    "myapp://home",            // 测试基本路径
    "myapp://home/",           // 测试基本路径末尾带斜杠
    "myapp://detail/123",      // 测试带参数路径
    "myapp://detail/123/",     // 测试带参数路径末尾带斜杠
    "myapp://detail/456?name=test",  // 测试带查询参数
    "myapp://detail/789/?price=99.9", // 测试末尾带斜杠和查询参数
    "myapp://product/123/info",       // 测试复杂路径
    "myapp://product/456/info/",      // 测试复杂路径末尾带斜杠
]

// 执行测试
for uri in testURIs {
    let result = router.route(to: uri)
    print("\n路由执行结果: \(result ? "成功" : "失败")")
    print(String(repeating: "=", count: 40))
}

print("\n=== 所有测试完成 ===")