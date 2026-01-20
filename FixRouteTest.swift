// 简单的路由匹配测试

import Foundation

// 模拟RouterManager的核心逻辑
class FixRouteTest {
    
    struct TestCase {
        let registeredPath: String
        let requestPath: String
        let expectedMatch: Bool
    }
    
    func runTests() {
        print("开始路由匹配测试...")
        
        let testCases: [TestCase] = [
            // 基本路径测试
            TestCase(registeredPath: "home", requestPath: "/home", expectedMatch: true),
            // 带参数路径测试
            TestCase(registeredPath: "detail/:id", requestPath: "/detail/123", expectedMatch: true),
            // 复杂参数路径测试
            TestCase(registeredPath: "product/:productId/info", requestPath: "/product/456/info", expectedMatch: true),
            // 不匹配路径测试
            TestCase(registeredPath: "detail/:id", requestPath: "/home", expectedMatch: false),
            // 参数数量不匹配测试
            TestCase(registeredPath: "detail/:id", requestPath: "/detail/123/extra", expectedMatch: false),
        ]
        
        var passedTests = 0
        var failedTests = 0
        
        for (index, testCase) in testCases.enumerated() {
            print("\n测试用例 \(index + 1):")
            print("注册路径: \(testCase.registeredPath)")
            print("请求路径: \(testCase.requestPath)")
            
            // 标准化注册路径
            let normalizedRegisteredPath = testCase.registeredPath.hasPrefix("/") ? testCase.registeredPath : "/" + testCase.registeredPath
            
            var parameters: [String: Any] = [:]
            let matchResult = matchPath(registeredPath: normalizedRegisteredPath, requestPath: testCase.requestPath, parameters: &parameters)
            
            print("注册路径组件: \(normalizedRegisteredPath.components(separatedBy: "/"))")
            print("请求路径组件: \(testCase.requestPath.components(separatedBy: "/"))")
            print("实际匹配结果: \(matchResult)")
            print("预期匹配结果: \(testCase.expectedMatch)")
            print("获取的参数: \(parameters)")
            
            if matchResult == testCase.expectedMatch {
                print("✅ 测试通过")
                passedTests += 1
            } else {
                print("❌ 测试失败：匹配结果不匹配")
                failedTests += 1
            }
        }
        
        print("\n测试总结:")
        print("通过测试: \(passedTests)")
        print("失败测试: \(failedTests)")
        print("总测试数: \(passedTests + failedTests)")
    }
    
    // 复制RouterManager中的matchPath方法
    private func matchPath(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
        // 将路径拆分为组件
        let registeredComponents = registeredPath.components(separatedBy: "/")
        let requestComponents = requestPath.components(separatedBy: "/")
        
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

// 运行测试
let routeTest = FixRouteTest()
routeTest.runTests()