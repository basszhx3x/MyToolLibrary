import XCTest
@testable import MyToolLibrary
import UIKit

// 模拟视图控制器，用于测试
final class MockViewController: UIViewController {
    var isPushed = false
    var isPresented = false
    var receivedParameters: [String: Any]?
}

// 辅助方法：解析URI（模拟RouterManager的内部实现）
fileprivate func parseURI(_ uri: String) -> (scheme: String, path: String, parameters: [String: Any])? {
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

// 辅助方法：路径匹配（模拟RouterManager的内部实现）
fileprivate func matchPath(registeredPath: String, requestPath: String, parameters: inout [String: Any]) -> Bool {
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

final class RouterManagerTests: XCTestCase {
    
    var router: RouterManager!
    
    override func setUp() {
        super.setUp()
        router = RouterManager.shared
        router.clearRoutes() // 清理之前的测试数据
    }
    
    override func tearDown() {
        router.clearRoutes()
        router = nil
        super.tearDown()
    }
    
    func testURIParsing() {
        // 测试简单URI
        let uri1 = "myapp://home"
        guard let (scheme1, path1, params1) = parseURI(uri1) else {
            XCTFail("URI解析失败")
            return
        }
        XCTAssertEqual(scheme1, "myapp", "Scheme解析错误")
        XCTAssertEqual(path1, "/home", "Path解析错误")
        XCTAssertTrue(params1.isEmpty, "参数解析错误")
        
        // 测试带查询参数的URI
        let uri2 = "myapp://detail/123?name=test&price=100"
        guard let (scheme2, path2, params2) = parseURI(uri2) else {
            XCTFail("URI解析失败")
            return
        }
        XCTAssertEqual(scheme2, "myapp", "Scheme解析错误")
        XCTAssertEqual(path2, "/detail/123", "Path解析错误")
        XCTAssertEqual(params2["name"] as? String, "test", "参数解析错误")
        XCTAssertEqual(params2["price"] as? String, "100", "参数解析错误")
    }
    
    func testPathMatching() {
        // 测试精确匹配
        var params1: [String: Any] = [:]
        let isMatch1 = matchPath(registeredPath: "/home", requestPath: "/home", parameters: &params1)
        XCTAssertTrue(isMatch1, "精确匹配失败")
        XCTAssertTrue(params1.isEmpty, "参数错误")
        
        // 测试路径参数匹配
        var params2: [String: Any] = [:]
        let isMatch2 = matchPath(registeredPath: "/detail/:id", requestPath: "/detail/123", parameters: &params2)
        XCTAssertTrue(isMatch2, "路径参数匹配失败")
        XCTAssertEqual(params2["id"] as? String, "123", "路径参数解析错误")
        
        // 测试不匹配的路径
        var params3: [String: Any] = [:]
        let isMatch3 = matchPath(registeredPath: "/home", requestPath: "/detail", parameters: &params3)
        XCTAssertFalse(isMatch3, "不匹配路径错误地匹配了")
        
        // 测试复杂路径参数匹配
        var params4: [String: Any] = [:]
        let isMatch4 = matchPath(registeredPath: "/user/:userId/post/:postId", requestPath: "/user/456/post/789", parameters: &params4)
        XCTAssertTrue(isMatch4, "复杂路径参数匹配失败")
        XCTAssertEqual(params4["userId"] as? String, "456", "用户ID参数解析错误")
        XCTAssertEqual(params4["postId"] as? String, "789", "帖子ID参数解析错误")
    }
    
    func testRouterRegistrationAndExecution() {
        let mockVC = MockViewController()
        
        // 注册路由
        router.register(path: "home") { (vc, params) in
            guard let mockVC = vc as? MockViewController else {
                return false
            }
            mockVC.isPushed = true
            mockVC.receivedParameters = params
            return true
        }
        
        // 注册带参数的路由
        router.register(path: "detail/:id") { (vc, params) in
            guard let mockVC = vc as? MockViewController else {
                return false
            }
            mockVC.isPushed = true
            mockVC.receivedParameters = params
            return true
        }
        
        // 测试执行路由
        let result1 = router.route(to: "myapp://home", from: mockVC)
        XCTAssertTrue(result1, "路由执行失败")
        XCTAssertTrue(mockVC.isPushed, "视图控制器未被标记为已推送")
        XCTAssertTrue(mockVC.receivedParameters?.isEmpty ?? false, "参数错误")
        
        // 重置模拟状态
        mockVC.isPushed = false
        mockVC.receivedParameters = nil
        
        // 测试执行带参数的路由
        let result2 = router.route(to: "myapp://detail/123?name=test", from: mockVC)
        XCTAssertTrue(result2, "带参数路由执行失败")
        XCTAssertTrue(mockVC.isPushed, "视图控制器未被标记为已推送")
        XCTAssertEqual(mockVC.receivedParameters?["id"] as? String, "123", "路径参数未正确传递")
        XCTAssertEqual(mockVC.receivedParameters?["name"] as? String, "test", "查询参数未正确传递")
    }
    
    func testDefaultRouter() {
        let mockVC = MockViewController()
        
        // 设置默认路由
        var defaultHandlerCalled = false
        router.registerDefault { (vc, params) in
            defaultHandlerCalled = true
            return true
        }
        
        // 测试执行未注册的路由
        let result = router.route(to: "myapp://unknown/path", from: mockVC)
        XCTAssertTrue(result, "默认路由执行失败")
        XCTAssertTrue(defaultHandlerCalled, "默认处理器未被调用")
    }
}
