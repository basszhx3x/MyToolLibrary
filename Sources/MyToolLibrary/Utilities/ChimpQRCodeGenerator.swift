//
//  ChimpQRCodeGenerator.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation
import CoreImage.CIFilterBuiltins

public class ChimpQRCodeGenerator {
    // 二维码滤镜
    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()
    // 生成二维码图片
    public func generateQRCode(from string: String,
                        size: CGSize = CGSize(width: 200, height: 200),
                        color: UIColor = .black,
                        backgroundColor: UIColor = .white) -> UIImage? {
        // 输入验证
        guard !string.isEmpty else {
            print("错误：输入字符串为空")
            return nil
        }
        
        // 设置二维码内容
        let data = Data(string.utf8)
        qrFilter.message = data
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // L, M, Q, H 四种级别

        // 生成基础二维码
        guard let ciImage = qrFilter.outputImage else {
            print("错误：无法生成二维码")
            return nil
        }
        
        // 应用颜色
        let coloredImage = applyColor(to: ciImage, foregroundColor: color, backgroundColor: backgroundColor)
        
        // 调整尺寸
        return resizeImage(coloredImage, to: size)
    }
    
    // 应用颜色
    // 应用颜色 - 简化版
    private func applyColor(to image: CIImage, foregroundColor: UIColor, backgroundColor: UIColor) -> CIImage {
        // 使用 CIFalseColor 滤镜直接设置前景色和背景色
        let filter = CIFilter(name: "CIFalseColor")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        filter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
        
        return filter.outputImage ?? image
    }
    
    // 调整图像尺寸
    private func resizeImage(_ image: CIImage, to size: CGSize) -> UIImage {
        let scaleX = size.width / image.extent.width
        let scaleY = size.height / image.extent.height
        let transformedImage = image.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        // 转换为 UIImage
        if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        // 备用方案
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
