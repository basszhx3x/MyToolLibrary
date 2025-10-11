//
//  UIImage+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation

public class BundleImage {
    
    public static func loadImage(named: String) -> UIImage? {
        let bundlePath = Bundle.init(for: BundleImage.self).path(forResource: "ChimpionTools", ofType: "bundle") ?? ""
        
        let bundle = Bundle(path: bundlePath)
        
        let image = UIImage.loadImage(named, inBundle: bundle)
        return image
    }
}

extension UIImage {
    
    
    /// 加载图片资源（从Images.xcassets加载图片）
    /// - Parameters:
    ///   - name: 图片名称
    ///   - bundle: 图片所在的bundle
    /// - Returns: UIImage?
    static func loadImage(_ name: String, inBundle bundle: Bundle?) -> UIImage? {
        if #available(iOS 13, *) {
            let image = UIImage.init(named: name, in: bundle, with: nil)
            return image
        } else {
            
            let image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
            return image
        }
    }
}

