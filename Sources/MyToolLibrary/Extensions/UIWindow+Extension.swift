//
//  UIWindow+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation
import UIKit

/// UIWindow的扩展方法，提供获取当前keyWindow的便捷方法
public extension UIWindow {
    /// 获取当前应用的keyWindow
    /// 
    /// 此方法兼容iOS 13之前和之后的版本，适配了UIScene架构
    /// - Returns: 当前的keyWindow，如果无法获取则返回nil
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            // iOS 13及以上版本，通过UIScene获取keyWindow
            if let window =  UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive}) // 筛选活跃的前台场景
                .map({$0 as? UIWindowScene}) // 转换为UIWindowScene
                .compactMap({$0}) // 移除nil值
                .first?.windows // 获取第一个场景的所有窗口
                .filter({$0.isKeyWindow}).first{ // 筛选keyWindow
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                // 如果通过Scene获取失败，尝试通过delegate获取
                return window
            }else{
                return nil
            }
        } else {
            // iOS 13以下版本，通过delegate获取window
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}
