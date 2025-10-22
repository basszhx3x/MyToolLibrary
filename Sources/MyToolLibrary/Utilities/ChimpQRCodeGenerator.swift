//
//  ChimpQRCodeGenerator.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit

/// 二维码生成器类
/// 
/// 提供简单易用的二维码创建功能，支持自定义尺寸、颜色和错误修正级别
public class ChimpQRCodeGenerator {
    /// CIContext实例，用于处理图像转换
    private let context = CIContext()
    /// 二维码生成滤镜
    private let qrFilter = CIFilter.qrCodeGenerator()
    /// 生成自定义二维码图片
    /// 
    /// 支持设置二维码内容、尺寸、前景色和背景色
    /// - Parameters:
    ///   - string: 要编码到二维码的文本内容
    ///   - size: 生成的二维码图片尺寸，默认为200x200
    ///   - color: 二维码前景色，默认为黑色
    ///   - backgroundColor: 二维码背景色，默认为白色
    /// - Returns: 生成的二维码UIImage对象，如果失败则返回nil
    public func generateQRCode(from string: String,
                        size: CGSize = CGSize(width: 200, height: 200),
                        color: UIColor = .black,
                        backgroundColor: UIColor = .white) -> UIImage? {
        // 输入验证
        guard !string.isEmpty else {
            print("错误：输入字符串为空")
            return nil
        }
        
        // 将文本转换为数据并设置到滤镜
        let data = Data(string.utf8)
        qrFilter.message = data
        // 设置错误修正级别为H（最高级别，可修复30%的损坏）
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // L, M, Q, H 四种级别

        // 生成基础二维码图像
        guard let ciImage = qrFilter.outputImage else {
            print("错误：无法生成二维码")
            return nil
        }
        
        // 应用自定义颜色
        let coloredImage = applyColor(to: ciImage, foregroundColor: color, backgroundColor: backgroundColor)
        
        // 调整图像到指定尺寸
        return resizeImage(coloredImage, to: size)
    }
    
    /// 为二维码应用自定义颜色
    /// 
    /// 使用CIFalseColor滤镜将黑白二维码转换为自定义颜色
    /// - Parameters:
    ///   - image: 原始二维码CIImage
    ///   - foregroundColor: 二维码前景色
    ///   - backgroundColor: 二维码背景色
    /// - Returns: 应用颜色后的CIImage
    private func applyColor(to image: CIImage, foregroundColor: UIColor, backgroundColor: UIColor) -> CIImage {
        // 使用 CIFalseColor 滤镜直接设置前景色和背景色
        let filter = CIFilter(name: "CIFalseColor")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0") // 前景色
        filter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1") // 背景色
        
        // 如果滤镜处理失败，返回原始图像
        return filter.outputImage ?? image
    }
    
    /// 调整CIImage尺寸并转换为UIImage
    /// 
    /// - Parameters:
    ///   - image: 要调整尺寸的CIImage
    ///   - size: 目标尺寸
    /// - Returns: 调整尺寸后的UIImage
    private func resizeImage(_ image: CIImage, to size: CGSize) -> UIImage {
        // 计算缩放比例
        let scaleX = size.width / image.extent.width
        let scaleY = size.height / image.extent.height
        
        // 应用缩放变换
        let transformedImage = image.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        // 首选方案：通过CIContext创建高质量CGImage
        if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        // 备用方案：直接从CIImage创建UIImage（质量可能略低）
        return UIImage(ciImage: transformedImage)
    }
}

// 使用示例
func createCustomQRCode() {
    let generator = ChimpQRCodeGenerator()
    let content = "https://example.com" // 二维码内容
    
    if let qrImage = generator.generateQRCode(
        from: content,
        size: CGSize(width: 300, height: 300),
        color: .blue,
        backgroundColor: .yellow
    ) {
        // 在 UI 中显示二维码
        let imageView = UIImageView(image: qrImage)
        imageView.contentMode = .scaleAspectFit
        // 添加到视图...
    }
}
