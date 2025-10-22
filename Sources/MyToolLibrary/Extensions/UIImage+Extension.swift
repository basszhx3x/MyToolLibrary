//
//  UIImage+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation
import UIKit

// 导入包含ImageFormat定义的模块

/// 用于从自定义Bundle中加载图片资源的工具类
public class BundleImage {
    
    /// 从ChimpionTools.bundle中加载指定名称的图片
    /// - Parameter named: 图片名称（不含扩展名）
    /// - Returns: 加载的图片对象，如果找不到则返回nil
    public static func loadImage(named: String) -> UIImage? {
        // 获取ChimpionTools.bundle的路径
        let bundlePath = Bundle.init(for: BundleImage.self).path(forResource: "ChimpionTools", ofType: "bundle") ?? ""
        
        // 创建Bundle实例
        let bundle = Bundle(path: bundlePath)
        
        // 调用UIImage扩展方法加载图片
        let image = UIImage.loadImage(named, inBundle: bundle)
        return image
    }
}

extension UIImage {
    
    /// 加载图片资源（适配iOS版本）
    /// - Parameters:
    ///   - name: 图片名称（不含扩展名）
    ///   - bundle: 图片所在的bundle，nil则使用默认bundle
    /// - Returns: 加载的图片对象，如果找不到则返回nil
    static func loadImage(_ name: String, inBundle bundle: Bundle?) -> UIImage? {
        if #available(iOS 13, *) {
            // iOS 13及以上版本使用新API
            let image = UIImage.init(named: name, in: bundle, with: nil)
            return image
        } else {
            // iOS 13以下版本使用兼容API
            let image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
            return image
        }
    }
    
    /// 调整图片大小
    /// - Parameter targetSize: 目标尺寸
    /// - Returns: 调整大小后的图片
    func resize(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image {
            _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    /// 裁剪图片
    /// - Parameter rect: 裁剪区域（相对于图片坐标系）
    /// - Returns: 裁剪后的图片
    func crop(to rect: CGRect) -> UIImage? {
        guard rect.size.width <= size.width && rect.size.height <= size.height else {
            return nil
        }
        
        if let cgImage = cgImage?.cropping(to: rect) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
    
    /// 为图片添加圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 添加圆角后的图片
    func rounded(radius: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image {
            context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
            context.cgContext.clip()
            draw(in: rect)
        }
    }
    
    /// 将图片裁剪为圆形
    /// - Returns: 圆形图片
    func circle() -> UIImage? {
        let radius = min(size.width, size.height) / 2
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: radius * 2, height: radius * 2))
        
        return renderer.image {
            context in
            let rect = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
            context.cgContext.addPath(UIBezierPath(ovalIn: rect).cgPath)
            context.cgContext.clip()
            
            // 计算裁剪矩形，居中显示
            let imageRect = CGRect(
                x: (radius * 2 - size.width) / 2,
                y: (radius * 2 - size.height) / 2,
                width: size.width,
                height: size.height
            )
            draw(in: imageRect)
        }
    }
    
    /// 添加阴影效果
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - blur: 阴影模糊半径
    ///   - opacity: 阴影透明度
    /// - Returns: 添加阴影后的图片
    func withShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 0, height: 2), blur: CGFloat = 4, opacity: Float = 0.5) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.width + blur * 2, height: size.height + blur * 2))
        
        return renderer.image {
            context in
            
            // 设置阴影
            context.cgContext.setShadow(offset: offset, blur: blur, color: color.cgColor)
            context.cgContext.setAlpha(CGFloat(opacity))
            
            // 绘制图片
            let imageRect = CGRect(x: blur, y: blur, width: size.width, height: size.height)
            draw(in: imageRect)
        }
    }
    
    /// 应用模糊效果
    /// - Parameter style: 模糊风格
    /// - Returns: 模糊后的图片
    @available(iOS 9.0, *)
    func blur(style: UIBlurEffect.Style = .regular) -> UIImage? {
        let imageRect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 创建模糊效果视图
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.bounds = imageRect
        
        // 绘制原图像
        draw(in: imageRect)
        
        // 应用模糊
        blurView.drawHierarchy(in: imageRect, afterScreenUpdates: true)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 将图片转换为灰度
    /// - Returns: 灰度图片
    func grayscale() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let context = CIContext(options: nil)
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else {
            return nil
        }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        if let cgImage = context.createCGImage(outputImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    /// 旋转图片
    /// - Parameter degrees: 旋转角度（度）
    /// - Returns: 旋转后的图片
    func rotate(degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let rotation = CGAffineTransform(rotationAngle: radians)
        rotatedViewBox.transform = rotation
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 移动原点到中心
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        // 应用旋转变换
        context.rotate(by: radians)
        // 绘制图片
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 获取图片的数据表示
    /// - Parameters:
    ///   - format: 图片格式
    ///   - compressionQuality: 压缩质量（0.0-1.0，仅JPEG有效）
    /// - Returns: 图片数据
    func data(format: ImageFormat = .png, compressionQuality: CGFloat = 1.0) -> Data? {
        switch format {
        case .jpeg:
            return jpegData(compressionQuality: compressionQuality)
        case .png:
            return pngData()
        default:
            return pngData() // 默认返回PNG格式
        }
    }
    
    /// 压缩图片到指定大小（近似值）
    /// - Parameters:
    ///   - targetSize: 目标大小（字节）
    ///   - maxIterations: 最大迭代次数
    /// - Returns: 压缩后的图片
    func compress(to targetSize: Int, maxIterations: Int = 10) -> Data? {
        var quality: CGFloat = 1.0
        guard var data = jpegData(compressionQuality: quality) else {
            return nil
        }
        
        if data.count <= targetSize {
            return data
        }
        
        // 二分查找合适的压缩质量
        var minQuality: CGFloat = 0.0
        var maxQuality: CGFloat = 1.0
        
        for _ in 0..<maxIterations {
            quality = (minQuality + maxQuality) / 2
            guard let newData = jpegData(compressionQuality: quality) else {
                continue
            }
            
            if newData.count < targetSize {
                minQuality = quality
                data = newData
            } else {
                maxQuality = quality
            }
        }
        
        return data
    }
    
    /// 为图片添加水印
    /// - Parameters:
    ///   - text: 水印文字
    ///   - font: 文字字体
    ///   - color: 文字颜色
    ///   - position: 水印位置
    /// - Returns: 添加水印后的图片
    func addWatermark(text: String, font: UIFont = .systemFont(ofSize: 14), color: UIColor = .white, position: CGPoint? = nil) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image {
            context in
            
            // 绘制原图
            draw(in: CGRect(origin: .zero, size: size))
            
            // 计算文字属性和位置
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: color
            ]
            
            let textSize = text.size(withAttributes: attributes)
            let defaultPosition = CGPoint(x: size.width - textSize.width - 10, y: size.height - textSize.height - 10)
            let finalPosition = position ?? defaultPosition
            
            // 绘制文字
            text.draw(at: finalPosition, withAttributes: attributes)
        }
    }
}

