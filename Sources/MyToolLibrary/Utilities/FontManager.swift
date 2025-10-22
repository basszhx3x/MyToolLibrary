//
//  FontManager.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2024/10/12.
//

import UIKit

/// 预定义的字体大小枚举
public enum FontChimpionSize: Float {
    /// 极小字体（辅助文字）- size 10
    case extraSmall = 10
    
    /// 微小字体（辅助文字）- size 12
    case tiny = 12
    
    /// 小字体（说明文字）- size 14
    case small = 14
    
    /// 常规字体（正文）- size 16
    case regular = 16
    
    /// 中等字体（小标题）- size 18
    case medium = 18
    
    /// 大中等字体（小标题）- size 20
    case largeMedium = 20
    
    /// 大字体（标题）- size 22
    case large = 22
    
    /// 超大字体（主标题）- size 28
    case extraLarge = 28
    
    /// 特大字体（特殊标题）- size 36
    case doubleExtraLarge = 36
}

/// 提供字体管理功能，支持PingFangSC系列字体和预定义字体大小
public class FontManager {
    
    // MARK: - 单例
    public static let shared = FontManager()
    private init() {}
    
    // MARK: - PingFangSC 字体获取方法


    /// 获取PingFangSC-Regular字体
    /// - Parameter size: 字体大小枚举
    /// - Returns: UIFont对象
    public static func pingFangRegular(_ size: FontChimpionSize) -> UIFont {
        return pingFangRegular(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Regular字体
    /// - Parameter size: 字体大小（浮点值）
    /// - Returns: UIFont对象
    public static func pingFangRegular(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: size) {
            return font
        }
        // 回退到系统字体
        return UIFont.systemFont(ofSize: size)
    }
    
    /// 获取PingFangSC-Medium字体
    /// - Parameter size: 字体大小枚举
    /// - Returns: UIFont对象
    public static func pingFangMedium(_ size: FontChimpionSize) -> UIFont {
        return pingFangMedium(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Medium字体
    /// - Parameter size: 字体大小（浮点值）
    /// - Returns: UIFont对象
    public static func pingFangMedium(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: size) {
            return font
        }
        // 回退到系统中等字体
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    /// 获取PingFangSC-Semibold字体
    /// - Parameter size: 字体大小枚举
    /// - Returns: UIFont对象
    public static func pingFangSemibold(_ size: FontChimpionSize) -> UIFont {
        return pingFangSemibold(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Semibold字体
    /// - Parameter size: 字体大小（浮点值）
    /// - Returns: UIFont对象
    public static func pingFangSemibold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Semibold", size: size) {
            return font
        }
        // 回退到系统半粗体字体
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    // MARK: - 便捷方法：通过字重获取字体
    
    /// 字重枚举
    public enum FontWeight {
        case regular
        case medium
        case semibold
    }
    
    /// 通过字重获取对应PingFangSC字体
    /// - Parameters:
    ///   - weight: 字重
    ///   - size: 字体大小枚举
    /// - Returns: UIFont对象
    public static func pingFangFont(weight: FontWeight, size: FontChimpionSize) -> UIFont {
        switch weight {
        case .regular:
            return pingFangRegular(size)
        case .medium:
            return pingFangMedium(size)
        case .semibold:
            return pingFangSemibold(size)
        }
    }
    
    /// 通过字重获取对应PingFangSC字体
    /// - Parameters:
    ///   - weight: 字重
    ///   - size: 字体大小（浮点值）
    /// - Returns: UIFont对象
    public static func pingFangFont(weight: FontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .regular:
            return pingFangRegular(size: size)
        case .medium:
            return pingFangMedium(size: size)
        case .semibold:
            return pingFangSemibold(size: size)
        }
    }
}

// MARK: - 扩展FontChimpionSize，提供获取字体的便捷方法
extension FontChimpionSize {
    /// 获取对应的数值大小
    public var value: CGFloat {
        return CGFloat(self.rawValue)
    }
    
    /// 获取PingFangSC-Regular字体
    public var pingFangRegular: UIFont {
        return FontManager.pingFangRegular(self)
    }
    
    /// 获取PingFangSC-Medium字体
    public var pingFangMedium: UIFont {
        return FontManager.pingFangMedium(self)
    }
    
    /// 获取PingFangSC-Semibold字体
    public var pingFangSemibold: UIFont {
        return FontManager.pingFangSemibold(self)
    }
}
