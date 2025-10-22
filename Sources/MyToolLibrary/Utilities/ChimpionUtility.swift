//
//  ChimpionUtility.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2024/10/11.
//

import UIKit

/// 提供常用的工具方法，包括屏幕尺寸、导航栏高度、刘海屏适配、环境判断、线程切换等
public class ChimpionUtility {
    
    // MARK: - 单例
    /// 单例实例，全局共享的工具类实例
    public static let shared = ChimpionUtility()
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
    // MARK: - 屏幕尺寸
    
    /// 设备屏幕的宽度
    /// 
    /// 获取UIScreen.main的bounds宽度，返回设备的物理屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 设备屏幕的高度
    /// 
    /// 获取UIScreen.main的bounds高度，返回设备的物理屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 设备屏幕的边界矩形
    /// 
    /// 返回设备屏幕的完整CGRect边界
    public static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    // MARK: - 系统栏高度
    
    /// 状态栏高度
    /// 
    /// 兼容iOS 13前后的不同获取方式
    /// - iOS 13+: 通过UIWindowScene的statusBarManager获取
    /// - iOS < 13: 通过UIApplication直接获取
    public static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return scene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// 导航栏高度（包含状态栏）
    /// 
    /// 计算方式：状态栏高度 + 标准导航栏高度(44pt)
    public static var navigationBarHeight: CGFloat {
        return statusBarHeight + 44.0 // 44是标准导航栏高度
    }
    
    /// TabBar高度
    /// 
    /// 计算方式：安全区域底部间距 + 标准TabBar高度(49pt)
    public static var tabBarHeight: CGFloat {
        return safeAreaBottom + 49.0 // 49是标准TabBar高度
    }
    
    // MARK: - 安全区域
    
    /// 安全区域顶部间距
    /// 
    /// - iOS 11+: 通过keyWindow的safeAreaInsets获取
    /// - iOS < 11: 返回状态栏高度
    public static var safeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            let window = keyWindow
            return window?.safeAreaInsets.top ?? 0
        } else {
            return statusBarHeight
        }
    }
    
    /// 安全区域底部间距
    /// 
    /// - iOS 11+: 通过keyWindow的safeAreaInsets获取，适配刘海屏设备
    /// - iOS < 11: 返回0
    public static var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            let window = keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    /// 获取当前keyWindow，支持iOS 13+ UIScene
    /// 
    /// - iOS 13+: 通过UIScene架构获取当前活跃的keyWindow
    /// - iOS < 13: 使用传统的keyWindow方法
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            // 通过UIScene获取当前活跃的keyWindow
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive}) // 筛选活跃的前台场景
                .compactMap({$0 as? UIWindowScene}) // 转换为UIWindowScene
                .first?.windows // 获取第一个场景的所有窗口
                .filter({$0.isKeyWindow}).first // 筛选keyWindow
        } else {
            // iOS 13以下版本直接返回
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 应用窗口宽度
    /// 
    /// 优先从keyWindow获取，如果keyWindow为nil则返回屏幕宽度
    public static var appWidth: CGFloat {
        return keyWindow?.bounds.width ?? screenWidth
    }
    
    /// 应用窗口高度
    /// 
    /// 优先从keyWindow获取，如果keyWindow为nil则返回屏幕高度
    public static var appHeight: CGFloat {
        return keyWindow?.bounds.height ?? screenHeight
    }
    
    // MARK: - 刘海屏判断
    
    /// 判断设备是否为刘海屏
    /// 
    /// 通过安全区域的上下边距判断
    /// - 当底部安全区域间距大于0或顶部安全区域间距大于20时，视为刘海屏
    public static var isNotchScreen: Bool {
        return safeAreaBottom > 0 || safeAreaTop > 20
    }
    
    // MARK: - 环境判断
    
    /// 判断当前是否为调试环境
    /// 
    /// 根据编译条件DEBUG判断
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// 判断当前是否为生产环境
    /// 
    /// 根据编译条件DEBUG判断
    public static var isRelease: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
    
    // MARK: - 线程切换
    
    /// 在主线程执行代码块
    /// 
    /// 如果当前已经在主线程，则直接执行；否则异步切换到主线程执行
    /// - Parameter block: 要执行的代码块
    public static func mainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    /// 在全局队列执行代码块
    /// 
    /// 适用于耗时操作，不会阻塞主线程
    /// - Parameters:
    ///   - qos: 服务质量，默认为.default
    ///   - block: 要执行的代码块
    public static func globalThread(qos: DispatchQoS.QoSClass = .default, _ block: @escaping () -> Void) {
        DispatchQueue.global(qos: qos).async {
            block()
        }
    }
    
    /// 延迟指定时间后执行代码块
    /// 
    /// 在主线程异步延迟执行指定的代码块
    /// - Parameters:
    ///   - delay: 延迟时间，单位为秒
    ///   - block: 要延迟执行的代码块
    /// - Returns: 创建的DispatchWorkItem，可以用于取消延迟执行
    @discardableResult
    public static func delay(_ delay: TimeInterval, _ block: @escaping () -> Void) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
    
    // MARK: - 设备信息
    
    /// 获取设备类型
    /// 
    /// 返回设备型号，如"iPhone"、"iPad"等
    public static var deviceType: String {
        return UIDevice.current.model
    }
    
    /// 获取设备系统版本
    /// 
    /// 返回iOS系统版本号，如"15.0"
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取应用版本号
    /// 
    /// 从Info.plist中读取CFBundleShortVersionString
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// 获取应用构建号
    /// 
    /// 从Info.plist中读取CFBundleVersion
    public static var appBuildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    // MARK: - 常用方法
    
    /// 获取当前应用的顶层视图控制器
    /// 
    /// 支持处理NavigationController和TabBarController的嵌套情况
    /// - Returns: 顶层UIViewController，如果无法获取则返回nil
    public static var topViewController: UIViewController? {
        // 从根控制器开始查找
        var topVC = keyWindow?.rootViewController
        
        // 处理模态视图
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        
        // 处理TabBarController
        if let tabBarVC = topVC as? UITabBarController {
            topVC = tabBarVC.selectedViewController
            
            // 处理TabBarController内的NavigationController
            if let navVC = topVC as? UINavigationController {
                topVC = navVC.topViewController
            }
        } 
        // 直接处理NavigationController
        else if let navVC = topVC as? UINavigationController {
            topVC = navVC.topViewController
        }
        
        return topVC
    }
    
    /// 计算文本在指定字体和最大尺寸下的实际尺寸
    /// 
    /// - Parameters:
    ///   - text: 要计算的文本内容
    ///   - font: 文本使用的字体
    ///   - maxSize: 文本允许的最大尺寸限制
    /// - Returns: 文本渲染所需的实际尺寸
    public static func textSize(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    /// 将图片保存到系统相册
    /// 
    /// 使用系统API将UIImage保存到用户相册，并提供完成回调
    /// - Parameters:
    ///   - image: 要保存到相册的UIImage对象
    ///   - completion: 保存完成后的回调，包含成功状态和可能的错误信息
    public static func saveImageToAlbum(_ image: UIImage, completion: ((Bool, Error?) -> Void)? = nil) {
        // 使用闭包捕获方式传递回调
        let completionHandler = SaveImageCompletionHandler(completion: completion)
        UIImageWriteToSavedPhotosAlbum(image, completionHandler, #selector(SaveImageCompletionHandler.onComplete), nil)
    }
    
    /// 保存图片到相册的回调处理器
    /// 
    /// 用于封装UIImageWriteToSavedPhotosAlbum需要的Objective-C回调
    private class SaveImageCompletionHandler: NSObject {
        private let completion: ((Bool, Error?) -> Void)?
        
        init(completion: ((Bool, Error?) -> Void)?) {
            self.completion = completion
            super.init()
        }
        
        @objc func onComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            completion?(error == nil, error)
        }
    }
    
    /// 获取应用的缓存总大小
    /// 
    /// 计算tmp目录和Caches目录下所有文件的总大小
    /// - Returns: 缓存大小，单位为字节
    public static func getCacheSize() -> UInt64 {
        var totalSize: UInt64 = 0
        
        // 计算tmp目录大小
        let tmpPath = NSTemporaryDirectory()
        if let tmpEnumerator = FileManager.default.enumerator(atPath: tmpPath) {
            for file in tmpEnumerator {
                let filePath = tmpPath + (file as! String)
                do {
                    let fileAttr = try FileManager.default.attributesOfItem(atPath: filePath)
                    if let fileSize = fileAttr[FileAttributeKey.size] as? UInt64 {
                        totalSize += fileSize
                    }
                } catch {
                    print("获取文件大小失败: \(error)")
                }
            }
        }
        
        // 计算Cache目录大小
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            if let cacheEnumerator = FileManager.default.enumerator(atPath: cachePath) {
                for file in cacheEnumerator {
                    let filePath = cachePath + "/" + (file as! String)
                    do {
                        let fileAttr = try FileManager.default.attributesOfItem(atPath: filePath)
                        if let fileSize = fileAttr[FileAttributeKey.size] as? UInt64 {
                            totalSize += fileSize
                        }
                    } catch {
                        print("获取文件大小失败: \(error)")
                    }
                }
            }
        }
        
        return totalSize
    }
    
    /// 清除应用缓存
    /// 
    /// 删除tmp目录和Caches目录下的所有文件
    /// - Returns: 是否清除成功，如果任何一个目录清除失败则返回false
    public static func clearCache() -> Bool {
        var success = true
        
        // 清除tmp目录
        let tmpPath = NSTemporaryDirectory()
        do {
            let tmpFiles = try FileManager.default.contentsOfDirectory(atPath: tmpPath)
            for file in tmpFiles {
                try FileManager.default.removeItem(atPath: tmpPath + file)
            }
        } catch {
            print("清除临时文件失败: \(error)")
            success = false
        }
        
        // 清除Cache目录
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            do {
                let cacheFiles = try FileManager.default.contentsOfDirectory(atPath: cachePath)
                for file in cacheFiles {
                    try FileManager.default.removeItem(atPath: cachePath + "/" + file)
                }
            } catch {
                print("清除缓存文件失败: \(error)")
                success = false
            }
        }
        
        return success
    }
    
    /// 将文件大小（字节）转换为人类可读的格式
    /// 
    /// 使用ByteCountFormatter将字节数转换为KB、MB、GB等格式
    /// - Parameter size: 要转换的文件大小，单位为字节
    /// - Returns: 格式化后的可读字符串，如"1.5 MB"
    public static func formattedFileSize(_ size: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}
