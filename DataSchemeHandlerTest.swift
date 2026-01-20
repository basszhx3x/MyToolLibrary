// Data Scheme Handler 测试

import Foundation

// 简化的RouterManager实现
class TestRouterManager {
    
    // MARK: - 属性
    private var routerRegistry: [String: () -> Bool] = [:]
    private var defaultHandler: (() -> Bool)?
    private var dataHandlerRegistry: [String: ([String: Any]) -> [String: Any]?] = [:]
    private var defaultDataHandler: (([String: Any]) -> [String: Any]?)?
    
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
    
    public func registerDataHandler(for path: String, handler: @escaping ([String: Any]) -> [String: Any]?) {
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        dataHandlerRegistry[normalizedPath] = handler
        print("注册Data Handler: \(normalizedPath)")
    }
    
    public func registerDefaultDataHandler(handler: @escaping ([String: Any]) -> [String: Any]?) {
        defaultDataHandler = handler
        print("注册默认Data Handler")
    }
    
    public func clearRoutes() {
        routerRegistry.removeAll()
        defaultHandler = nil
        dataHandlerRegistry.removeAll()
        defaultDataHandler = nil
        print("清理所有注册")
    }
    
    // MARK: - URI解析
    private func parseURI(_ uri: String) -> (scheme: String, path: String, parameters: [String: Any])? {
        guard let schemeRange = uri.range(of: "://") else { return nil }
        
        let scheme = String(uri[..<schemeRange.lowerBound])
        let remainingString = String(uri[schemeRange.upperBound...])
        
        var path: String
        var parameters: [String: Any] = [:]
        
        if let queryStartIndex = remainingString.range(of: "?") {
            path = String(remainingString[..<queryStartIndex.lowerBound])
            let queryString = String(remainingString[queryStartIndex.upperBound...])
            
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
            path = remainingString
        }
        
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        
        return (scheme, path, parameters)
    }
    
    // MARK: - 路径匹配
    private func matchPath(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
        func cleanPath(_ path: String) -> String {
            var cleanedPath = path
            if cleanedPath != "/" && cleanedPath.hasSuffix("/") {
                cleanedPath = String(cleanedPath.dropLast())
            }
            return cleanedPath
        }
        
        let cleanedRegisteredPath = cleanPath(registeredPath)
        let cleanedRequestPath = cleanPath(requestPath)
        
        let registeredComponents = cleanedRegisteredPath.components(separatedBy: "/")
        let requestComponents = cleanedRequestPath.components(separatedBy: "/")
        
        if registeredComponents.count != requestComponents.count {
            return false
        }
        
        for (index, registeredComponent) in registeredComponents.enumerated() {
            let requestComponent = requestComponents[index]
            
            if registeredComponent.hasPrefix(":") {
                let parameterName = String(registeredComponent.dropFirst())
                parameters[parameterName] = requestComponent
            } else if registeredComponent != requestComponent {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - 路由方法
    @discardableResult
    public func route(to uri: String) -> Bool {
        print("\n=== 测试路由: \(uri) ===")
        
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
            print("Data Scheme 路由处理成功")
            return true
        }
        
        return false
    }
    
    // MARK: - 数据获取方法
    @discardableResult
    public func getData(from uri: String) -> [String: Any]? {
        print("\n=== 测试获取数据: \(uri) ===")
        
        guard let (scheme, path, parametersDict) = parseURI(uri), 
              scheme.lowercased() == "data" else {
            print("不是有效的 Data Scheme URI")
            return nil
        }
        
        print("URI解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("URL参数: \(parametersDict)")
        
        var requestParameters = parametersDict
        let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
        requestParameters["pathComponents"] = pathComponents
        requestParameters["path"] = path
        
        // 查找匹配的数据处理闭包
        for (registeredPath, handler) in dataHandlerRegistry {
            print("\n尝试匹配 Data Handler:")
            print("注册路径: \(registeredPath)")
            print("请求路径: \(path)")
            
            var matchParams = requestParameters
            if matchPath(registeredPath: registeredPath, requestPath: path, parameters: &matchParams) {
                print("路径匹配成功!")
                print("最终请求参数: \(matchParams)")
                
                if let handlerResult = handler(matchParams) {
                    print("Data Handler 执行成功!")
                    print("Data Handler 返回结果: \(handlerResult)")
                    return handlerResult
                } else {
                    print("Data Handler 执行失败")
                }
            } else {
                print("路径匹配失败!")
            }
        }
        
        // 调用默认数据处理闭包
        if let defaultDataHandler = defaultDataHandler {
            print("\n调用默认Data Handler")
            if let defaultResult = defaultDataHandler(requestParameters) {
                print("默认Data Handler 执行成功!")
                print("默认Data Handler 返回结果: \(defaultResult)")
                return defaultResult
            } else {
                print("默认Data Handler 执行失败")
            }
        }
        
        print("\n未找到匹配的Data Handler，返回模拟数据")
        return [
            "success": false,
            "message": "未找到匹配的Data Handler",
            "requestParams": requestParameters
        ]
    }
}

// 运行测试
print("=== Data Scheme Handler 测试 ===")
print("Swift版本: 6.2.1")
print(String(repeating: "=", count: 60))

let router = TestRouterManager()

// 注册路由
router.register(path: "home") { 
    print("执行home路由处理器")
    return true
}

router.registerDefault { 
    print("执行默认路由处理器")
    return true
}

// 注册Data Handler
router.registerDataHandler(for: "user/:userId") { params in
    print("\n[Data Handler] 获取用户数据，用户ID: \(params["userId"] ?? "")")
    
    return [
        "success": true,
        "message": "获取用户数据成功",
        "data": [
            "userId": params["userId"] ?? "",
            "username": "用户_\(params["userId"] ?? "")",
            "email": "user_\(params["userId"] ?? "")@example.com",
            "nickname": params["nickname"] as? String ?? "",
            "avatar": "https://example.com/avatars/\(params["userId"] ?? "")",
            "createdAt": "2026-01-01T00:00:00Z",
            "isVip": true,
            "points": 1000
        ]
    ]
}

router.registerDataHandler(for: "product/:productId") { params in
    print("\n[Data Handler] 获取产品数据，产品ID: \(params["productId"] ?? "")")
    
    return [
        "success": true,
        "message": "获取产品数据成功",
        "data": [
            "productId": params["productId"] ?? "",
            "name": params["name"] as? String ?? "产品_\(params["productId"] ?? "")",
            "price": params["price"] as? String ?? "99.9",
            "stock": params["stock"] as? String ?? "100",
            "category": "electronics",
            "brand": "Example Brand",
            "description": "这是产品\(params["productId"] ?? "")的详细描述",
            "image": "https://example.com/products/\(params["productId"] ?? "")/image.jpg"
        ]
    ]
}

router.registerDefaultDataHandler { params in
    print("\n[默认Data Handler] 处理未匹配的Data Scheme请求")
    return [
        "success": false,
        "message": "未找到匹配的Data Handler",
        "requestParams": params
    ]
}

// 测试用例
let testURIs = [
    "myapp://home",                    // 普通路由
    "data://user/123?nickname=张三",    // 用户数据
    "data://product/456?name=iPhone&price=12999",  // 产品数据
    "data://weather/789?cityName=北京",  // 未注册的Data Handler
]

// 执行测试
for uri in testURIs {
    print("\n" + String(repeating: "=", count: 60))
    
    if uri.hasPrefix("myapp://") {
        let result = router.route(to: uri)
        print("\n路由执行结果: \(result ? "成功" : "失败")")
    } else if uri.hasPrefix("data://") {
        let dataResult = router.getData(from: uri)
        print("\n数据获取结果: \(dataResult != nil ? "成功" : "失败")")
        
        if let result = dataResult {
            print("\n最终返回数据:")
            for (key, value) in result {
                if let dictValue = value as? [String: Any] {
                    print("\(key):")
                    for (subKey, subValue) in dictValue {
                        if let arrayValue = subValue as? [[String: Any]] {
                            print("  \(subKey):")
                            for item in arrayValue {
                                print("    item)")
                            }
                        } else {
                            print("  \(subKey): \(subValue)")
                        }
                    }
                } else if let arrayValue = value as? [[String: Any]] {
                    print("\(key):")
                    for item in arrayValue {
                        print("  item)")
                    }
                } else {
                    print("\(key): \(value)")
                }
            }
        }
    }
}

print("\n=== 所有测试完成 ===")