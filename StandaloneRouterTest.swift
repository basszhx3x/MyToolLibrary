//
//  StandaloneRouterTest.swift
//  
//  Created by AI Assistant on 2026-01-16.
//  独立的RouterManager测试文件，包含完整实现
//

import Foundation

// MARK: - RouterManager 完整实现
class RouterManager {
    // MARK: - 类型定义
    
    /// 路由处理闭包类型
    public typealias RouterHandler = (String, [String: Any]) -> Bool
    
    // MARK: - 单例模式
    
    /// 单例实例
    public static let shared = RouterManager()
    
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
    // MARK: - 属性
    
    /// 路由注册表，存储URI与处理闭包的映射关系
    private var routerRegistry: [String: RouterHandler] = [:]
    
    /// 默认路由处理闭包，当没有找到匹配的路由时调用
    private var defaultHandler: RouterHandler?
    
    /// 异步数据获取闭包，用于从外部获取数据
    private var asyncDataHandler: ((String, [String: Any], @escaping ([String: Any]?, Error?) -> Void) -> Void)?
    
    // MARK: - 注册方法
    
    /// 注册路由
    /// 
    /// - Parameters:
    ///   - uri: 统一资源标识符（如"app://home"）
    ///   - handler: 路由处理闭包，返回Bool表示是否成功处理了路由
    public func register(uri: String, handler: @escaping RouterHandler) {
        // 标准化URI（去除查询参数和片段标识符）
        let normalizedUri = normalizeURI(uri)
        routerRegistry[normalizedUri] = handler
        print("注册路由: \(normalizedUri)")
    }
    
    /// 注册默认路由处理闭包
    /// 
    /// - Parameter handler: 默认路由处理闭包
    public func registerDefault(handler: @escaping RouterHandler) {
        defaultHandler = handler
        print("注册默认路由处理闭包")
    }
    
    /// 清理所有路由注册
    /// 
    /// 移除所有已注册的路由和默认处理闭包，主要用于测试
    public func clearRoutes() {
        routerRegistry.removeAll()
        defaultHandler = nil
        asyncDataHandler = nil
    }
    
    /// 设置Data Scheme的异步数据处理闭包
    /// 
    /// - Parameter handler: 异步数据处理闭包，接收URI和参数，完成后调用completion返回结果
    public func setDataHandler(_ handler: @escaping (String, [String: Any], @escaping ([String: Any]?, Error?) -> Void) -> Void) {
        self.asyncDataHandler = handler
        print("设置异步Data Scheme处理闭包")
    }
    
    // MARK: - 路由方法
    
    /// 路由到指定URI
    /// 
    /// - Parameter uri: 统一资源标识符（如"app://home?param1=value1&param2=value2"）
    /// - Returns: Bool表示是否成功处理了路由
    @discardableResult
    public func route(to uri: String) -> Bool {
        print("\n=== 处理路由 URI: \(uri) ===")
        
        // 解析URI
        guard let (scheme, path, parametersDict) = parseURI(uri) else {
            print("URI解析失败")
            return handleDefaultRoute(uri, parametersDict: [:])
        }
        
        print("解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("URL参数: \(parametersDict)")
        
        // 如果scheme是data，则调用数据处理方法
        if scheme.lowercased() == "data" {
            print("检测到Data Scheme，不进行页面跳转")
            // 这里可以返回true表示已处理，或者根据需要返回false
            return true
        }
        
        // 标准化URI（去除查询参数和片段标识符）以用于路由匹配
        let normalizedUri = normalizeURI(uri)
        
        // 查找匹配的路由处理闭包
        if let handler = routerRegistry[normalizedUri] {
            print("找到匹配的路由处理闭包")
            return handler(uri, parametersDict)
        }
        
        // 查找不带结尾斜杠的匹配路由（如果原路由带斜杠）
        if normalizedUri.hasSuffix("/") {
            let uriWithoutTrailingSlash = String(normalizedUri.dropLast())
            if let handler = routerRegistry[uriWithoutTrailingSlash] {
                print("找到匹配的路由处理闭包（不带结尾斜杠）")
                return handler(uri, parametersDict)
            }
        }
        
        // 查找带结尾斜杠的匹配路由（如果原路由不带斜杠）
        if !normalizedUri.hasSuffix("/") {
            let uriWithTrailingSlash = normalizedUri + "/"
            if let handler = routerRegistry[uriWithTrailingSlash] {
                print("找到匹配的路由处理闭包（带结尾斜杠）")
                return handler(uri, parametersDict)
            }
        }
        
        // 如果没有找到匹配的路由，则使用默认处理闭包
        print("未找到匹配的路由，使用默认处理闭包")
        return handleDefaultRoute(uri, parametersDict: parametersDict)
    }
    
    /// 异步处理 Data Scheme 的 URI 并返回结果数据
    /// 
    /// - Parameters:
    ///   - uri: 统一资源标识符（如"data://user/123?name=test"）
    ///   - completion: 完成回调，返回结果数据或错误
    public func getData(from uri: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        // 解析URI
        guard let (scheme, path, parametersDict) = parseURI(uri), 
              scheme.lowercased() == "data" else {
            completion(nil, NSError(domain: "RouterManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "无效的URI格式或非Data Scheme"]))
            return
        }
        
        print("\n=== 处理 Data Scheme URI: \(uri) ===")
        print("解析结果:")
        print("Scheme: \(scheme)")
        print("Path: \(path)")
        print("URL参数: \(parametersDict)")
        
        // 解析路径参数
        let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
        
        // 构建请求参数
        var requestParameters = parametersDict
        requestParameters["pathComponents"] = pathComponents
        requestParameters["path"] = path
        requestParameters["scheme"] = scheme
        
        // 检查是否设置了异步数据处理闭包
        if let asyncDataHandler = asyncDataHandler {
            print("调用外部异步Data Scheme处理闭包")
            
            // 直接调用外部提供的异步数据处理闭包
            asyncDataHandler(uri, requestParameters) { (result, error) in
                DispatchQueue.main.async {
                    print("\n异步Data Scheme处理完成!")
                    if let result = result {
                        print("返回结果: \(result)")
                    } else if let error = error {
                        print("返回错误: \(error)")
                    }
                    completion(result, error)
                }
            }
        } else {
            // 没有设置数据处理闭包
            print("未设置Data Scheme处理闭包")
            completion(nil, NSError(domain: "RouterManager", code: 501, userInfo: [NSLocalizedDescriptionKey: "未设置Data Scheme处理闭包"]))
        }
    }
    
    // MARK: - 私有方法
    
    /// 解析URI
    /// 
    /// - Parameter uri: 统一资源标识符
    /// - Returns: (scheme, path, parameters) 元组，如果解析失败返回nil
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
            
            // 按&分割查询参数
            let queryParameters = queryString.components(separatedBy: "&")
            
            // 解析每个查询参数
            for param in queryParameters where !param.isEmpty {
                let components = param.components(separatedBy: "=")
                if components.count >= 2 {
                    let key = components[0]
                    let value = components[1]
                    // 解码URL编码的参数值
                    if let decodedValue = value.removingPercentEncoding {
                        parameters[key] = decodedValue
                    } else {
                        parameters[key] = value
                    }
                } else if components.count == 1 {
                    // 只有键没有值的情况
                    let key = components[0]
                    parameters[key] = ""
                }
            }
        } else {
            // 没有查询参数的情况
            path = remainingString
        }
        
        return (scheme: scheme, path: path, parameters: parameters)
    }
    
    /// 标准化URI（去除查询参数和片段标识符）
    /// 
    /// - Parameter uri: 统一资源标识符
    /// - Returns: 标准化后的URI
    private func normalizeURI(_ uri: String) -> String {
        // 查找查询参数的开始位置
        if let queryStartIndex = uri.range(of: "?") {
            return String(uri[..<queryStartIndex.lowerBound])
        }
        // 查找片段标识符的开始位置
        if let fragmentStartIndex = uri.range(of: "#") {
            return String(uri[..<fragmentStartIndex.lowerBound])
        }
        // 没有查询参数和片段标识符的情况
        return uri
    }
    
    /// 处理默认路由
    /// 
    /// - Parameters:
    ///   - uri: 统一资源标识符
    ///   - parametersDict: URI参数字典
    /// - Returns: Bool表示是否成功处理了路由
    private func handleDefaultRoute(_ uri: String, parametersDict: [String: Any]) -> Bool {
        if let handler = defaultHandler {
            print("执行默认路由处理闭包")
            return handler(uri, parametersDict)
        }
        
        print("未找到默认路由处理闭包")
        return false
    }
}

// MARK: - Date扩展：用于测试中格式化日期
extension Date {
    /// 将Date转换为ISO8601格式的字符串
    var iso8601String: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}

// MARK: - 测试外部数据获取服务
class MockDataService {
    // 模拟从外部API获取用户数据
    func getUserData(userId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        // 模拟网络请求延迟
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1.0) {
            let userData: [String: Any] = [
                "id": userId,
                "name": "张三",
                "email": "zhangsan@example.com",
                "age": 30,
                "gender": "男",
                "createdAt": "2026-01-01T00:00:00Z"
            ]
            completion(userData, nil)
        }
    }
    
    // 模拟从外部API获取产品数据
    func getProductData(productId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        // 模拟网络请求延迟
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.8) {
            let productData: [String: Any] = [
                "id": productId,
                "name": "iPhone 16 Pro",
                "price": 12999.0,
                "stock": 50,
                "brand": "Apple",
                "category": "手机",
                "createdAt": "2026-01-10T00:00:00Z"
            ]
            completion(productData, nil)
        }
    }
    
    // 模拟从外部API获取天气数据
    func getWeatherData(cityId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        // 模拟网络请求延迟
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.5) {
            let weatherData: [String: Any] = [
                "cityId": cityId,
                "cityName": "北京",
                "temperature": 25,
                "humidity": "50%",
                "windSpeed": "5km/h",
                "weatherCondition": "晴天",
                "icon": "sunny",
                "forecast": [
                    ["date": "2026-01-16", "temp": "26", "weather": "多云"],
                    ["date": "2026-01-17", "temp": "24", "weather": "小雨"]
                ]
            ]
            completion(weatherData, nil)
        }
    }
}

// MARK: - 测试入口
func testExternalDataRetrieval() {
    print("开始测试外部数据获取功能...")
    
    // 创建模拟数据服务
    let dataService = MockDataService()
    
    // 获取RouterManager实例
    let routerManager = RouterManager.shared
    
    // 设置外部异步数据处理闭包
    routerManager.setDataHandler { (uri: String, params: [String: Any], completion: @escaping ([String: Any]?, Error?) -> Void) in
        print("\n=== 外部数据处理闭包被调用 ===")
        print("URI: \(uri)")
        print("参数: \(params)")
        
        // 解析路径组件
        guard let pathComponents = params["pathComponents"] as? [String], !pathComponents.isEmpty else {
            let error = NSError(domain: "DataService", code: 400, userInfo: [NSLocalizedDescriptionKey: "无效的路径组件"])
            completion(nil as [String: Any]?, error)
            return
        }
        
        // 根据路径类型调用不同的外部数据服务
        let dataType = pathComponents[0]
        switch dataType {
        case "user":
            if pathComponents.count > 1 {
                let userId = pathComponents[1]
                dataService.getUserData(userId: userId) { (userData, error) in
                    if let userData = userData {
                        let result: [String: Any] = [
                            "success": true,
                            "message": "用户数据获取成功",
                            "timestamp": Date().iso8601String,
                            "data": userData
                        ]
                        completion(result, nil)
                    } else {
                        let error = NSError(domain: "DataService", code: 500, userInfo: [NSLocalizedDescriptionKey: "用户数据获取失败"])
                        completion(nil as [String: Any]?, error)
                    }
                }
            }
        case "product":
            if pathComponents.count > 1 {
                let productId = pathComponents[1]
                dataService.getProductData(productId: productId) { (productData, error) in
                    if let productData = productData {
                        let result: [String: Any] = [
                            "success": true,
                            "message": "产品数据获取成功",
                            "timestamp": Date().iso8601String,
                            "data": productData
                        ]
                        completion(result, nil)
                    } else {
                        let error = NSError(domain: "DataService", code: 500, userInfo: [NSLocalizedDescriptionKey: "产品数据获取失败"])
                        completion(nil as [String: Any]?, error)
                    }
                }
            }
        case "weather":
            if pathComponents.count > 1 {
                let cityId = pathComponents[1]
                dataService.getWeatherData(cityId: cityId) { (weatherData, error) in
                    if let weatherData = weatherData {
                        let result: [String: Any] = [
                            "success": true,
                            "message": "天气数据获取成功",
                            "timestamp": Date().iso8601String,
                            "data": weatherData
                        ]
                        completion(result, nil)
                    } else {
                        let error = NSError(domain: "DataService", code: 500, userInfo: [NSLocalizedDescriptionKey: "天气数据获取失败"])
                        completion(nil as [String: Any]?, error)
                    }
                }
            }
        default:
            let error = NSError(domain: "DataService", code: 404, userInfo: [NSLocalizedDescriptionKey: "不支持的数据类型: \(dataType)"])
            completion(nil as [String: Any]?, error)
        }
    }
    
    // 测试用户数据获取
    print("\n===== 测试获取用户数据 =====")
    routerManager.getData(from: "data://user/123?name=test") { (result, error) in
        if let error = error {
            print("获取用户数据失败: \(error)")
        } else if let result = result {
            print("获取用户数据成功: \(result)")
            
            // 测试产品数据获取
            print("\n===== 测试获取产品数据 =====")
            routerManager.getData(from: "data://product/789?name=iPhone&price=12999&stock=50") { (result, error) in
                if let error = error {
                    print("获取产品数据失败: \(error)")
                } else if let result = result {
                    print("获取产品数据成功: \(result)")
                    
                    // 测试天气数据获取
                    print("\n===== 测试获取天气数据 =====")
                    routerManager.getData(from: "data://weather/101010100?cityName=北京") { (result, error) in
                        if let error = error {
                            print("获取天气数据失败: \(error)")
                        } else if let result = result {
                            print("获取天气数据成功: \(result)")
                        }
                        print("\n所有测试完成!")
                    }
                }
            }
        }
    }
    
    // 防止程序立即退出
    RunLoop.main.run(until: Date(timeIntervalSinceNow: 5.0))
}

// 运行测试
testExternalDataRetrieval()
