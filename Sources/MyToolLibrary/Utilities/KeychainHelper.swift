//
//  KeychainHelper.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import Foundation
import KeychainSwift
/**
 在引入pod库后，编译报错 Sandbox：rsync.sanba deny(1) file-write-create xxx

 解决办法：

 出现这种情况的原因，是因为在xcode15以后引入pod库，User Script Sandboxing默认是YES允许脚本沙盒的，所以改为NO即可：
 */
/// Keychain操作辅助类
/// 
/// 封装了KeychainSwift库的常用操作，提供简洁的接口来存储、读取和删除敏感数据
public struct KeychainHelper {
    /// 内部使用的KeychainSwift实例
    private static let keychain = KeychainSwift()
    
    /// 将字符串值保存到Keychain中
    /// 
    /// 安全地存储敏感数据，如用户名、密码、令牌等
    /// - Parameters:
    ///   - key: 用于标识存储项的键名
    ///   - value: 要存储的字符串值
    /// - Returns: 如果保存成功则返回true，否则返回false
    @discardableResult
    public static func save(key: String, value: String) -> Bool {
        keychain.set(value, forKey: key)
    }
    
    /// 从Keychain中读取指定键的字符串值
    /// 
    /// 根据提供的键名从Keychain中检索存储的数据
    /// - Parameter key: 存储项的键名，如为nil则返回nil
    /// - Returns: 存储的字符串值，如果键不存在则返回nil
    public static func getValue(key: String?) -> String? {
        guard let account = key else {
            return nil
        }
        return keychain.get(account)
    }
    
    /// 从Keychain中删除指定键的数据
    /// 
    /// 移除指定键名下存储的所有数据
    /// - Parameter key: 要删除的存储项的键名
    /// - Returns: 如果删除成功则返回true，否则返回false
    @discardableResult
    public static func delete(key: String) -> Bool {
        keychain.delete(key)
    }
    
    /// 清空Keychain中的所有数据
    /// 
    /// 删除当前应用程序在Keychain中存储的所有数据
    /// - Returns: 如果清空成功则返回true，否则返回false
    @discardableResult
    public static func deleteAll() -> Bool {
        keychain.clear()
    }
    
}
