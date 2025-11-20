//
//  WKWebview+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/11/20.
//

import Foundation
import WebKit

public extension WKWebView {
    
    func isWebViewBlank() -> Bool {
        // 获取 WKWebView 的截图
        let screenshot = captureScreenshot()
        
        // 判断截图是否为空白
        return isBlankImage(screenshot)
    }

    // 截图方法
    func captureScreenshot() -> UIImage {
        // 创建图形上下文
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { context in
            // 渲染 WKWebView 的内容到图形上下文
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

    // 判断截图是否为空白
    func isBlankImage(_ image: UIImage) -> Bool {
        guard let cgImage = image.cgImage else { return true }

        // 获取截图的像素数据
        let width = cgImage.width
        let height = cgImage.height
        
        guard let data = cgImage.dataProvider?.data,let ptr = CFDataGetBytePtr(data) else { return true }
        
        // 遍历像素并检查是否大部分像素是白色
        var whitePixelCount = 0
        var totalPixelCount = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = ((height - y - 1) * width + x) * 4 // RGBA
                let red = ptr[pixelIndex]
                let green = ptr[pixelIndex + 1]
                let blue = ptr[pixelIndex + 2]
                
                // 判断是否是白色像素
                if red == 255 && green == 255 && blue == 255 {
                    whitePixelCount += 1
                }
                
                totalPixelCount += 1
            }
        }
        
        // 如果白色像素超过一定比例，则认为是空白页
        let whitePercentage = Double(whitePixelCount) / Double(totalPixelCount)
        return whitePercentage > 0.95 // 95% 以上为白色，认为是空白
    }
}
