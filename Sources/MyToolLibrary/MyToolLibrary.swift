// MyToolLibrary.swift
// 主文件，用于导出所有公共接口

@_exported import Foundation

#if canImport(UIKit)
@_exported import UIKit
#endif

// 这里可以添加库的版本信息或其他全局配置
public struct MyToolLibrary {
    public static let version = "1.2.1"
}
