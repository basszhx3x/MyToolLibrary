//
//  Color+Extensions.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/22.
//

import UIKit

/// UIColor扩展，提供颜色到图片的转换和其他实用功能
public extension UIColor {
    
    /// 从颜色生成UIImage
    /// 
    /// 创建一个指定尺寸、指定颜色的纯色图片
    /// - Parameter size: 生成的图片尺寸，默认为1x1像素
    /// - Returns: 生成的纯色UIImage对象
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        // 创建一个基于指定尺寸的图形上下文
        let renderer = UIGraphicsImageRenderer(size: size)
        
        // 在图形上下文中绘制纯色矩形
        let image = renderer.image { context in
            // 将当前颜色设置为填充颜色
            self.setFill()
            // 绘制一个覆盖整个上下文的矩形
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        return image
    }
    
    /// 从十六进制字符串创建UIColor
    /// 
    /// 支持以下格式："#RGB"、"#RGBA"、"#RRGGBB"、"#RRGGBBAA"
    /// - Parameter hexString: 十六进制颜色字符串
    /// - Returns: 解析得到的UIColor对象，如果解析失败则返回白色
    convenience init(hexString: String) {
        // 移除可能的前缀"#"
        let hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var rgba: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        // 尝试解析十六进制字符串
        if Scanner(string: hex).scanHexInt64(&rgba) {
            // 根据字符串长度判断格式
            switch hex.count {
            case 3: // #RGB
                r = CGFloat((rgba & 0xF00) >> 8) / 15.0
                g = CGFloat((rgba & 0x0F0) >> 4) / 15.0
                b = CGFloat(rgba & 0x00F) / 15.0
            case 4: // #RGBA
                r = CGFloat((rgba & 0xF000) >> 12) / 15.0
                g = CGFloat((rgba & 0x0F00) >> 8) / 15.0
                b = CGFloat((rgba & 0x00F0) >> 4) / 15.0
                a = CGFloat(rgba & 0x000F) / 15.0
            case 6: // #RRGGBB
                r = CGFloat((rgba & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgba & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgba & 0x0000FF) / 255.0
            case 8: // #RRGGBBAA
                r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgba & 0x000000FF) / 255.0
            default:
                // 格式不支持，使用默认白色
                r = 1.0
                g = 1.0
                b = 1.0
            }
        }
        
        // 初始化颜色
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// 获取颜色的十六进制字符串表示
    /// 
    /// 输出格式为"#RRGGBBAA"，包含完整的RGB和Alpha通道
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // 获取颜色的RGB和Alpha值
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // 转换为0-255的整数并格式化为十六进制字符串
        return String(format: "#%02X%02X%02X%02X", 
                     Int(r * 255), 
                     Int(g * 255), 
                     Int(b * 255), 
                     Int(a * 255))
    }
    
    /// 获取颜色的反色
    /// 
    /// 计算并返回与当前颜色相反的颜色
    var inverseColor: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // 获取颜色的RGB和Alpha值
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // 计算反色（255 - 原值）
        return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
    
    /// 创建带有透明度的新颜色
    /// 
    /// 使用当前颜色的RGB值，但应用新的透明度
    /// - Parameter alpha: 新的透明度值，范围0.0-1.0
    /// - Returns: 新的透明色
    func withAlpha(_ alpha: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        // 获取颜色的RGB值
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        // 创建新的颜色，应用新的透明度
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 生成渐变色图片
    /// 
    /// 创建一个从起始颜色到结束颜色的线性渐变图片
    /// - Parameters:
    ///   - toColor: 渐变结束的颜色
    ///   - size: 生成图片的尺寸
    ///   - startPoint: 渐变起始点，默认为左上角
    ///   - endPoint: 渐变结束点，默认为右下角
    /// - Returns: 生成的渐变色UIImage对象
    func gradientImage(toColor: UIColor, 
                       size: CGSize = CGSize(width: 200, height: 200),
                       startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                       endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) -> UIImage? {
        // 创建渐变图层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = [self.cgColor, toColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // 创建一个临时视图来渲染渐变
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // 确保能够获取当前上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        // 将渐变图层渲染到上下文中
        gradientLayer.render(in: context)
        
        // 从上下文中获取图片
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return gradientImage
    }
}
