// 斜杠匹配测试

import Foundation

// 简化的路由匹配逻辑
func testSlashMatch() {
    let registeredPath = "detail/:id"
    let uri = "myapp://detail/123/"
    
    print("测试斜杠匹配:")
    print("注册路径: \(registeredPath)")
    print("测试URI: \(uri)")
    
    // 1. 标准化注册路径
    let normalizedRegisteredPath = registeredPath.hasPrefix("/") ? registeredPath : "/" + registeredPath
    print("标准化注册路径: \(normalizedRegisteredPath)")
    
    // 2. 解析URI
    guard let (_, path, _) = parseURI(uri) else {
        print("URI解析失败")
        return
    }
    
    print("URI解析路径: \(path)")
    
    // 3. 路径匹配 - 原始逻辑
    var parameters1: [String: Any] = [:]
    let matchResult1 = matchPathOriginal(registeredPath: normalizedRegisteredPath, requestPath: path, parameters: &parameters1)
    
    print("\n原始匹配结果: \(matchResult1 ? "匹配成功" : "匹配失败")")
    
    // 4. 路径匹配 - 修复后逻辑
    var parameters2: [String: Any] = [:]
    let matchResult2 = matchPathFixed(registeredPath: normalizedRegisteredPath, requestPath: path, parameters: &parameters2)
    
    print("\n修复后匹配结果: \(matchResult2 ? "匹配成功" : "匹配失败")")
    
    if matchResult2 {
        print("解析到的参数: \(parameters2)")
    }
}

// 复制修复后的parseURI方法
func parseURI(_ uri: String) -> (scheme: String, path: String, parameters: [String: Any])? {
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

// 原始的matchPath方法
func matchPathOriginal(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
    // 将路径拆分为组件
    let registeredComponents = registeredPath.components(separatedBy: "/")
    let requestComponents = requestPath.components(separatedBy: "/")
    
    print("原始匹配路径组件:")
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
        } else if registeredComponent != requestComponent {
            // 如果不是路径参数且不匹配，则返回false
            return false
        }
    }
    
    return true
}

// 修复后的matchPath方法
func matchPathFixed(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
    // 清理路径，移除末尾的斜杠
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
    
    print("\n修复后匹配路径组件:")
    print("清理后的注册路径: \(cleanedRegisteredPath)")
    print("清理后的请求路径: \(cleanedRequestPath)")
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
        } else if registeredComponent != requestComponent {
            // 如果不是路径参数且不匹配，则返回false
            return false
        }
    }
    
    return true
}

// 运行测试
testSlashMatch()