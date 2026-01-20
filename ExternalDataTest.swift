//
//  ExternalDataTest.swift
//  MyToolLibrary
//
//  Created by AI Assistant on 2026-01-16.
//

import Foundation

// 测试外部数据获取服务
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

// 测试入口
func testExternalDataRetrieval() {
    print("开始测试外部数据获取功能...")
    
    // 创建模拟数据服务
    let dataService = MockDataService()
    
    // 获取RouterManager实例
    let routerManager = RouterManager.shared
    
    // 设置外部异步数据处理闭包
    routerManager.setDataHandler { (uri, params, completion) in
        print("\n=== 外部数据处理闭包被调用 ===")
        print("URI: \(uri)")
        print("参数: \(params)")
        
        // 解析路径组件
        guard let pathComponents = params["pathComponents"] as? [String], !pathComponents.isEmpty else {
            let error = NSError(domain: "DataService", code: 400, userInfo: [NSLocalizedDescriptionKey: "无效的路径组件"])
            completion(nil, error)
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
                        completion(nil, error)
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
                        completion(nil, error)
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
                        completion(nil, error)
                    }
                }
            }
        default:
            let error = NSError(domain: "DataService", code: 404, userInfo: [NSLocalizedDescriptionKey: "不支持的数据类型: \(dataType)"])
            completion(nil, error)
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
