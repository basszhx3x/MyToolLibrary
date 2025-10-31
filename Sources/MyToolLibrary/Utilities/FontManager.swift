//
//  FontManager.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2024/10/12.
//

import UIKit

/// 预定义的字体大小枚举
/// 
/// 提供常用的字体大小选项，用于统一应用中的文本样式
public enum FontChimpionSize {
    /// 极小字体（辅助文字）- size 10
    /// 
    /// 适用于非常小的辅助说明文字
    case extraSmall
    
    /// 微小字体（辅助文字）- size 12
    /// 
    /// 适用于次要的辅助说明文字
    case tiny
    
    /// 小字体（说明文字）- size 14
    /// 
    /// 适用于说明性文字、标签等
    case small
    
    /// 常规字体（正文）- size 16
    /// 
    /// 适用于主要内容文本，阅读体验最佳
    case regular
    
    /// 中等字体（小标题）- size 18
    /// 
    /// 适用于小节标题或重要内容的强调
    case medium
    
    /// 大中等字体（小标题）- size 20
    /// 
    /// 适用于较大的小标题或需要突出显示的文本
    case largeMedium
    
    /// 大字体（标题）- size 22
    /// 
    /// 适用于中等级别的页面标题
    case large
    
    /// 超大字体（主标题）- size 28
    /// 
    /// 适用于页面主标题或重要内容的强调
    case extraLarge
    
    /// 特大字体（特殊标题）- size 36
    /// 
    /// 适用于特殊场合的大标题或需要特别强调的文本
    case doubleExtraLarge
    
    /// 自定义字体大小
    /// 
    /// 允许设置任意自定义的字体大小
    case custom(size: Float)
}

/// 字体管理类
/// 
/// 提供统一的字体获取接口，支持PingFangSC系列字体和预定义字体大小
public class FontManager {
    
    // MARK: - 单例
    /// FontManager的共享实例
    public static let shared = FontManager()
    
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
    // MARK: - PingFangSC 字体获取方法


    /// 获取PingFangSC-Regular字体
    /// 
    /// 根据指定的字体大小枚举获取PingFangSC-Regular字体
    /// - Parameter size: 字体大小枚举，从预定义的FontChimpionSize中选择
    /// - Returns: 对应大小的PingFangSC-Regular字体，如果找不到则返回系统默认字体
    public static func pingFangRegular(_ size: FontChimpionSize) -> UIFont {
        return pingFangRegular(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Regular字体
    /// 
    /// 根据指定的字体大小值获取PingFangSC-Regular字体
    /// - Parameter size: 字体大小（浮点值），可以是任意有效尺寸
    /// - Returns: 对应大小的PingFangSC-Regular字体，如果找不到则返回系统默认字体
    public static func pingFangRegular(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: size) {
            return font
        }
        // 回退到系统字体
        return UIFont.systemFont(ofSize: size)
    }
    
    /// 获取PingFangSC-Medium字体
    /// 
    /// 根据指定的字体大小枚举获取PingFangSC-Medium字体
    /// - Parameter size: 字体大小枚举，从预定义的FontChimpionSize中选择
    /// - Returns: 对应大小的PingFangSC-Medium字体，如果找不到则返回系统中等字体
    public static func pingFangMedium(_ size: FontChimpionSize) -> UIFont {
        return pingFangMedium(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Medium字体
    /// 
    /// 根据指定的字体大小值获取PingFangSC-Medium字体
    /// - Parameter size: 字体大小（浮点值），可以是任意有效尺寸
    /// - Returns: 对应大小的PingFangSC-Medium字体，如果找不到则返回系统中等字体
    public static func pingFangMedium(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: size) {
            return font
        }
        // 回退到系统中等字体
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    /// 获取PingFangSC-Semibold字体
    /// 
    /// 根据指定的字体大小枚举获取PingFangSC-Semibold字体
    /// - Parameter size: 字体大小枚举，从预定义的FontChimpionSize中选择
    /// - Returns: 对应大小的PingFangSC-Semibold字体，如果找不到则返回系统半粗体字体
    public static func pingFangSemibold(_ size: FontChimpionSize) -> UIFont {
        return pingFangSemibold(size: CGFloat(size.rawValue))
    }
    
    /// 获取PingFangSC-Semibold字体
    /// 
    /// 根据指定的字体大小值获取PingFangSC-Semibold字体
    /// - Parameter size: 字体大小（浮点值），可以是任意有效尺寸
    /// - Returns: 对应大小的PingFangSC-Semibold字体，如果找不到则返回系统半粗体字体
    public static func pingFangSemibold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Semibold", size: size) {
            return font
        }
        // 回退到系统半粗体字体
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    // MARK: - 便捷方法：通过字重获取字体
    
    /// 字重枚举
    /// 
    /// 提供三种常用字重选项
    public enum FontWeight {
        case regular
        case medium
        case semibold
    }
    
    /// 通过字重获取对应PingFangSC字体
    /// 
    /// 根据指定的字重和字体大小枚举获取对应的PingFangSC字体
    /// - Parameters:
    ///   - weight: 字重，从FontWeight枚举中选择
    ///   - size: 字体大小枚举，从预定义的FontChimpionSize中选择
    /// - Returns: 对应字重和大小的PingFangSC字体，如果找不到则返回对应的系统字体
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
    /// 
    /// 根据指定的字重和字体大小值获取对应的PingFangSC字体
    /// - Parameters:
    ///   - weight: 字重，从FontWeight枚举中选择
    ///   - size: 字体大小（浮点值），可以是任意有效尺寸
    /// - Returns: 对应字重和大小的PingFangSC字体，如果找不到则返回对应的系统字体
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
/// FontChimpionSize扩展
/// 
/// 为字体大小枚举添加便捷方法，直接获取对应字体
extension FontChimpionSize {
    /// 获取对应的数值大小
    /// 
    /// - Returns: 将枚举值转换为CGFloat类型的字体大小
    public var value: CGFloat {
        return CGFloat(self.rawValue)
    }
    
    /// 获取原始浮点数值
    /// 
    /// - Returns: 字体大小的浮点值
    public var rawValue: Float {
        switch self {
        case .extraSmall: return 10
        case .tiny: return 12
        case .small: return 14
        case .regular: return 16
        case .medium: return 18
        case .largeMedium: return 20
        case .large: return 22
        case .extraLarge: return 28
        case .doubleExtraLarge: return 36
        case .custom(let size): return size
        }
    }
    
    /// 获取PingFangSC-Regular字体
    /// 
    /// - Returns: 对应大小的PingFangSC-Regular字体，如果找不到则返回系统默认字体
    public var pingFangRegular: UIFont {
        return FontManager.pingFangRegular(self)
    }
    
    /// 获取PingFangSC-Medium字体
    /// 
    /// - Returns: 对应大小的PingFangSC-Medium字体，如果找不到则返回系统中等字体
    public var pingFangMedium: UIFont {
        return FontManager.pingFangMedium(self)
    }
    
    /// 获取PingFangSC-Semibold字体
    /// 
    /// - Returns: 对应大小的PingFangSC-Semibold字体，如果找不到则返回系统半粗体字体
    public var pingFangSemibold: UIFont {
        return FontManager.pingFangSemibold(self)
    }
}
