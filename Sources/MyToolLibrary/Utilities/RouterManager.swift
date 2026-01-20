//
//  RouterManager.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2026/1/16.
//

import UIKit

/// 路由处理闭包类型
/// - Parameters:
///   - viewController: 目标视图控制器
///   - parameters: 解析出的参数字典
/// - Returns: 是否成功处理路由
public typealias RouterHandler = (_ viewController: UIViewController, _ parameters: [String: Any]) -> Bool

/// 路由管理器
/// 
/// 提供URI路由功能，可以根据传入的URI跳转到不同的页面
public class RouterManager {
    
    // MARK: - 单例
    /// 单例实例，全局共享的路由管理器实例
    public static let shared = RouterManager()
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
    // MARK: - 属性
    /// 路由注册表，存储URI与处理闭包的映射关系
    private var routerRegistry: [String: RouterHandler] = [:]
    /// 默认路由处理闭包，当没有找到匹配的路由时调用
    private var defaultHandler: RouterHandler?
    
    // MARK: - 注册方法
    
    /// 注册路由
    /// 
    /// - Parameters:
    ///   - path: 路由路径（如"home"、"detail/:id"）
    ///   - handler: 路由处理闭包
    public func register(path: String, handler: @escaping RouterHandler) {
        // 标准化路径，确保有前导斜杠
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        routerRegistry[normalizedPath] = handler
    }
    
    /// 注册默认路由处理
    /// 
    /// 当没有找到匹配的路由时调用此处理闭包
    /// - Parameter handler: 默认路由处理闭包
    public func registerDefault(handler: @escaping RouterHandler) {
        defaultHandler = handler
    }
    
    /// 清理所有路由注册
    /// 
    /// 移除所有已注册的路由和默认处理闭包，主要用于测试
    public func clearRoutes() {
        routerRegistry.removeAll()
        defaultHandler = nil
    }
    

    
    // MARK: - 路由方法
    
    /// 路由到指定URI
    /// 
    /// - Parameters:
    ///   - uri: 统一资源标识符（如"myapp://home"、"myapp://detail/123?name=test"）
    ///   - from: 来源视图控制器（默认使用顶层视图控制器）
    ///   - animated: 是否使用动画
    /// - Returns: 是否成功路由
    @discardableResult
    public func route(to uri: String, from: UIViewController? = nil, animated: Bool = true) -> Bool {
        // 解析URI
        guard let (_, path, parametersDict) = parseURI(uri) else {
            return false
        }
        
        // 获取来源视图控制器
        let sourceVC = from ?? getTopViewController()
        guard let sourceVC = sourceVC else {
            return false
        }
        
        // 查找匹配的路由处理闭包
        for (registeredPath, handler) in routerRegistry {
            var parameters = parametersDict
            if matchPath(registeredPath: registeredPath, requestPath: path, parameters: &parameters) {
                return handler(sourceVC, parameters)
            }
        }
        
        // 调用默认路由处理
        if let defaultHandler = defaultHandler {
            return defaultHandler(sourceVC, parametersDict)
        }
        
        return false
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
    
    /// 匹配路由路径
    /// 
    /// - Parameters:
    ///   - registeredPath: 注册的路由路径
    ///   - requestPath: 请求的路由路径
    ///   - parameters: 参数字典（用于存储路径参数）
    /// - Returns: 是否匹配
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
    
    /// 获取顶层视图控制器
    /// 
    /// - Returns: 当前顶层视图控制器，如果无法获取则返回nil
    private func getTopViewController() -> UIViewController? {
        // 获取当前活跃的窗口场景
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topVC = window.rootViewController
        
        // 处理模态视图
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        
        // 处理导航控制器
        if let navVC = topVC as? UINavigationController {
            topVC = navVC.topViewController
        }
        
        // 处理标签栏控制器
        if let tabVC = topVC as? UITabBarController {
            topVC = tabVC.selectedViewController
        }
        
        return topVC
    }
}

/// RouterManager扩展，提供便捷的URL路由方法
public extension RouterManager {
    /// 路由到指定URL
    /// 
    /// - Parameters:
    ///   - url: URL对象
    ///   - from: 来源视图控制器（默认使用顶层视图控制器）
    ///   - animated: 是否使用动画
    /// - Returns: 是否成功路由
    @discardableResult
    func route(to url: URL, from: UIViewController? = nil, animated: Bool = true) -> Bool {
        return route(to: url.absoluteString, from: from, animated: animated)
    }
}



// RouterManager扩展，提供类型安全的路由注册和调用
public extension RouterManager {
    /// 类型安全的路由注册
    /// 
    /// - Parameters:
    ///   - path: 路由路径
    ///   - builder: 视图控制器构建闭包
    ///   - presentationStyle: 展示方式
    func register<T: UIViewController>(path: String, builder: @escaping ([String: Any]) -> T?, presentationStyle: PresentationStyle = .push) {
        register(path: path) { sourceVC, parameters in
            guard let targetVC = builder(parameters) else {
                return false
            }
            
            switch presentationStyle {
            case .push:
                // 如果来源视图控制器不是导航控制器，则获取其导航控制器
                guard let navigationVC = sourceVC.navigationController else {
                    return false
                }
                navigationVC.pushViewController(targetVC, animated: true)
                return true
            case .present:
                sourceVC.present(targetVC, animated: true, completion: nil)
                return true
            case .modal(let style, let transitionStyle):
                let navigationVC = UINavigationController(rootViewController: targetVC)
                navigationVC.modalPresentationStyle = style
                navigationVC.modalTransitionStyle = transitionStyle
                sourceVC.present(navigationVC, animated: true, completion: nil)
                return true
            }
        }
    }
    
    /// 展示方式枚举
    enum PresentationStyle {
        case push              // 使用导航控制器push
        case present           // 直接present
        case modal(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) // 模态展示（带样式）
    }
}
