// 简化的Data Scheme处理测试

import Foundation

// 模拟URI解析函数
func parseURI(_ uri: String) -> (scheme: String, path: String, parameters: [String: Any])? {
    guard let schemeRange = uri.range(of: "://") else {
        return nil
    }
    
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

// 模拟Data Scheme处理函数
func handleDataScheme(uri: String) -> [String: Any]? {
    guard let (scheme, path, parametersDict) = parseURI(uri), 
          scheme.lowercased() == "data" else {
        return nil
    }
    
    var result: [String: Any] = parametersDict
    result["path"] = path
    
    let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
    if !pathComponents.isEmpty {
        result["pathComponents"] = pathComponents
        
        switch pathComponents[0] {
        case "user":
            result["userData"] = [
                "id": pathComponents.count > 1 ? pathComponents[1] : "",
                "name": parametersDict["name"] as? String ?? "",
                "email": parametersDict["email"] as? String ?? "",
                "age": parametersDict["age"] as? String ?? ""
            ]
        case "product":
            result["productData"] = [
                "id": pathComponents.count > 1 ? pathComponents[1] : "",
                "name": parametersDict["name"] as? String ?? "",
                "price": parametersDict["price"] as? String ?? "",
                "stock": parametersDict["stock"] as? String ?? ""
            ]
        case "config":
            result["configData"] = [
                "theme": parametersDict["theme"] as? String ?? "light",
                "language": parametersDict["language"] as? String ?? "zh-CN",
                "version": "1.0.0"
            ]
        default:
            result["dataType"] = pathComponents[0]
            result["message"] = "Data scheme processed successfully"
        }
    }
    
    return result
}

// 测试用例
let testURIs = [
    "data://user/123?name=张三&email=zhangsan@example.com",
    "data://product/456?name=iPhone&price=9999&stock=100",
    "data://config?theme=dark&language=en-US",
    "data://custom/path/123/456?param1=value1&param2=value2",
    "myapp://home",  // 非Data Scheme，应该返回nil
]

print("=== Data Scheme处理测试 ===")
print("Swift版本: 6.2.1")
print(String(repeating: "=", count: 50))

for uri in testURIs {
    print("\n测试URI: \(uri)")
    
    if let (scheme, path, params) = parseURI(uri) {
        print("URI解析结果:")
        print("  Scheme: \(scheme)")
        print("  Path: \(path)")
        print("  参数: \(params)")
        
        if scheme.lowercased() == "data" {
            print("  检测到Data Scheme，不进行页面跳转")
            
            if let dataResult = handleDataScheme(uri: uri) {
                print("\n  Data Scheme处理结果:")
                for (key, value) in dataResult {
                    if let dictValue = value as? [String: Any] {
                        print("  \(key):")
                        for (subKey, subValue) in dictValue {
                            print("    \(subKey): \(subValue)")
                        }
                    } else if let arrayValue = value as? [String] {
                        print("  \(key): \(arrayValue)")
                    } else {
                        print("  \(key): \(value)")
                    }
                }
            }
        }
    } else {
        print("URI解析失败")
    }
    
    print(String(repeating: "-", count: 50))
}

print("\n=== 测试完成 ===")