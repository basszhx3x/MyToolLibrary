//
//  UIImage+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation
import UIKit

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
}

