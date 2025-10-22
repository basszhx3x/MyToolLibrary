//
//  MyToolLibrary.swift
//  MyToolLibrary
//
//  主文件，用于导出所有公共接口和定义库的基本信息
//

/// 导出基础库，确保在整个库中可用
@_exported import Foundation

/// 条件导出UIKit，仅在支持的平台上可用
#if canImport(UIKit)
@_exported import UIKit
#endif

/// MyToolLibrary框架的主结构，包含版本信息和其他全局配置
/// 
/// 此类提供对库版本的访问，可用于检查兼容性和日志记录
public struct MyToolLibrary {
    /// 当前库的版本号
    /// 
    /// 遵循语义化版本规范(MAJOR.MINOR.PATCH)
    /// - MAJOR: 不兼容的API变更
    /// - MINOR: 向下兼容的功能性新增
    /// - PATCH: 向下兼容的问题修正
    public static let version = "1.2.1"
}
