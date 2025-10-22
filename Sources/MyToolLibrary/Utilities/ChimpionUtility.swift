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
    public static let shared = ChimpionUtility()
    private init() {}
    
    // MARK: - 屏幕尺寸
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 屏幕尺寸
    public static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    // MARK: - 系统栏高度
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return scene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// 导航栏高度（包含状态栏）
    public static var navigationBarHeight: CGFloat {
        return statusBarHeight + 44.0 // 44是标准导航栏高度
    }
    
    /// TabBar高度
    public static var tabBarHeight: CGFloat {
        return safeAreaBottom + 49.0 // 49是标准TabBar高度
    }
    
    // MARK: - 安全区域
    
    /// 安全区域顶部间距
    public static var safeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            let window = keyWindow
            return window?.safeAreaInsets.top ?? 0
        } else {
            return statusBarHeight
        }
    }
    
    /// 安全区域底部间距
    public static var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            let window = keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    /// 获取当前keyWindow，支持iOS 13+ UIScene
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 应用窗口宽度
    public static var appWidth: CGFloat {
        return keyWindow?.bounds.width ?? screenWidth
    }
    
    /// 应用窗口高度
    public static var appHeight: CGFloat {
        return keyWindow?.bounds.height ?? screenHeight
    }
    
    // MARK: - 刘海屏判断
    
    /// 是否是刘海屏设备
    public static var isNotchScreen: Bool {
        return safeAreaBottom > 0 || safeAreaTop > 20
    }
    
    // MARK: - 环境判断
    
    /// 是否是调试环境
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// 是否是生产环境
    public static var isRelease: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
    
    // MARK: - 线程切换
    
    /// 在主线程执行
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
    
    /// 在全局队列执行
    /// - Parameters:
    ///   - qos: 服务质量
    ///   - block: 要执行的代码块
    public static func globalThread(qos: DispatchQoS.QoSClass = .default, _ block: @escaping () -> Void) {
        DispatchQueue.global(qos: qos).async {
            block()
        }
    }
    
    /// 延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - block: 要执行的代码块
    @discardableResult
    public static func delay(_ delay: TimeInterval, _ block: @escaping () -> Void) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
    
    // MARK: - 设备信息
    
    /// 设备类型
    public static var deviceType: String {
        return UIDevice.current.model
    }
    
    /// 设备系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 应用版本号
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// 应用构建号
    public static var appBuildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    // MARK: - 常用方法
    
    /// 获取当前顶层控制器
    public static var topViewController: UIViewController? {
        var topVC = keyWindow?.rootViewController
        
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        
        if let tabBarVC = topVC as? UITabBarController {
            topVC = tabBarVC.selectedViewController
            
            if let navVC = topVC as? UINavigationController {
                topVC = navVC.topViewController
            }
        } else if let navVC = topVC as? UINavigationController {
            topVC = navVC.topViewController
        }
        
        return topVC
    }
    
    /// 计算文本尺寸
    /// - Parameters:
    ///   - text: 文本内容
    ///   - font: 字体
    ///   - maxSize: 最大尺寸
    /// - Returns: 文本尺寸
    public static func textSize(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    /// 保存图片到相册
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - completion: 完成回调
    public static func saveImageToAlbum(_ image: UIImage, completion: ((Bool, Error?) -> Void)? = nil) {
        // 使用闭包捕获方式传递回调
        let completionHandler = SaveImageCompletionHandler(completion: completion)
        UIImageWriteToSavedPhotosAlbum(image, completionHandler, #selector(SaveImageCompletionHandler.onComplete), nil)
    }
    
    /// 保存图片回调处理器
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
    
    /// 获取缓存大小（字节）
    public static var cacheSize: UInt64 {
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
    
    /// 清除缓存
    @discardableResult
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
    
    /// 将文件大小转换为可读格式
    /// - Parameter size: 文件大小（字节）
    /// - Returns: 可读格式的大小字符串
    public static func formatFileSize(_ size: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}
