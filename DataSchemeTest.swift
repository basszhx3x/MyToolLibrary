// Data Scheme 测试

import Foundation

// 简化的RouterManager实现
class TestRouterManager {
    
    // MARK: - 属性
    private var routerRegistry: [String: () -> Bool] = [:]
    private var defaultHandler: (() -> Bool)?
    
    // MARK: - 注册方法
    public func register(path: String, handler: @escaping () -> Bool) {
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        routerRegistry[normalizedPath] = handler
        print("注册路由: \(normalizedPath)")
    }
    
    public func registerDefault(handler: @escaping () -> Bool) {
        defaultHandler = handler
        print("注册默认路由处理器")
    }
    
    // MARK: - 路由方法
    @discardableResult
    public func route(to uri: String) -> Bool {
        print("\n=== 测试路由: \(uri) ===")
        
        // 解析URI
        guard let (scheme, path, parametersDict) = parseURI(uri) else {
            print("URI解析失败")
            return false
        }
        
        print("URI解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("Parameters: \(parametersDict)")
        
        // 处理 data scheme
        if scheme.lowercased() == "data" {
            print("\n检测到 Data Scheme，不进行页面跳转")
            print("Data Scheme 处理成功")
            return true
        }
        
        // 查找匹配的路由处理闭包
        for (registeredPath, handler) in routerRegistry {
            print("\n尝试匹配路由:")
            print("注册路径: \(registeredPath)")
            print("请求路径: \(path)")
            
            var matchParams: [String: Any] = parametersDict
            if matchPath(registeredPath: registeredPath, requestPath: path, parameters: &matchParams) {
                print("路径匹配成功!")
                print("最终参数: \(matchParams)")
                return handler()
            } else {
                print("路径匹配失败!")
            }
        }
        
        // 调用默认路由处理
        if let defaultHandler = defaultHandler {
            print("\n调用默认路由处理器")
            return defaultHandler()
        }
        
        print("未找到匹配的路由")
        return false
    }
    
    // MARK: - 数据处理方法
    @discardableResult
    public func getData(from uri: String) -> [String: Any]? {
        print("\n=== 测试数据获取: \(uri) ===")
        
        // 解析URI
        guard let (scheme, path, parametersDict) = parseURI(uri), 
              scheme.lowercased() == "data" else {
            print("不是有效的 Data Scheme URI")
            return nil
        }
        
        print("URI解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("Parameters: \(parametersDict)")
        
        // 构建结果数据
        var result: [String: Any] = parametersDict
        
        // 添加路径信息到结果
        result["path"] = path
        
        // 解析路径参数
        let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
        if !pathComponents.isEmpty {
            // 添加路径组件信息
            result["pathComponents"] = pathComponents
            
            // 根据不同的路径返回不同的模拟数据
            switch pathComponents[0] {
            case "user":
                // 模拟用户数据
                result["userData"] = [
                    "id": pathComponents.count > 1 ? pathComponents[1] : "",
                    "name": parametersDict["name"] as? String ?? "",
                    "email": parametersDict["email"] as? String ?? "",
                    "age": parametersDict["age"] as? String ?? ""
                ]
            case "product":
                // 模拟产品数据
                result["productData"] = [
                    "id": pathComponents.count > 1 ? pathComponents[1] : "",
                    "name": parametersDict["name"] as? String ?? "",
                    "price": parametersDict["price"] as? String ?? "",
                    "stock": parametersDict["stock"] as? String ?? ""
                ]
            case "config":
                // 模拟配置数据
                result["configData"] = [
                    "theme": parametersDict["theme"] as? String ?? "light",
                    "language": parametersDict["language"] as? String ?? "zh-CN",
                    "version": "1.0.0"
                ]
            default:
                // 通用数据
                result["dataType"] = pathComponents[0]
                result["message"] = "Data scheme processed successfully"
            }
        }
        
        print("\nData Scheme 数据处理结果:")
        print("Result: \(result)")
        
        return result
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
                    let value = keyValue[1]
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
        
        // 将路径拆分为组件
        let registeredComponents = cleanedRegisteredPath.components(separatedBy: "/")
        let requestComponents = cleanedRequestPath.components(separatedBy: "/")
        
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
            } else if registeredComponent != requestComponent {
                // 如果不是路径参数且不匹配，则返回false
                return false
            }
        }
        
        return true
    }
}

// 运行Data Scheme测试
print("=== Data Scheme 测试 ===")

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

router.registerDefault { 
    print("执行默认路由处理器")
    return true
}

// 测试用例
let testURIs = [
    "myapp://home",                    // 测试普通路由
    "myapp://detail/123",              // 测试带参数路由
    "data://user/123",                 // 测试Data Scheme (用户数据)
    "data://product/456?name=iPhone&price=9999",  // 测试Data Scheme (产品数据带参数)
    "data://config?theme=dark&language=en-US",    // 测试Data Scheme (配置数据)
    "data://custom/path/123/456?param1=value1&param2=value2",  // 测试复杂Data Scheme路径
]

// 执行路由测试
print("\n=== 路由测试结果 ===")
for uri in testURIs {
    let result = router.route(to: uri)
    print("\n路由执行结果: \(result ? "成功" : "失败")")
    print(String(repeating: "=", count: 60))
}

// 执行数据获取测试
print("\n=== 数据获取测试结果 ===")
let dataURIs = [
    "data://user/123?name=张三&email=zhangsan@example.com",
    "data://product/789?name=MacBook&price=12999&stock=50",
    "data://config?theme=light&language=zh-CN",
    "myapp://home",  // 非Data Scheme，应该返回nil
]

for uri in dataURIs {
    print("\n测试获取数据: \(uri)")
    
    // 简化的数据获取逻辑
    guard let (scheme, path, params) = router.parseURI(uri), 
          scheme.lowercased() == "data" else {
        print("不是有效的Data Scheme URI，返回nil")
        continue
    }
    
    // 构建结果数据
    var result: [String: Any] = params
    result["path"] = path
    
    let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
    result["pathComponents"] = pathComponents
    
    if !pathComponents.isEmpty {
        result["dataType"] = pathComponents[0]
    }
    
    print("获取到的数据: \(result)")
}

print("\n=== 所有测试完成 ===")