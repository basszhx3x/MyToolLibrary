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
public struct KeychainHelper {
    private static let keychain = KeychainSwift()
    
    // 存储用户名和密码‌:ml-citation{ref="3,4" data="citationList"}
    @discardableResult
    static func save(key: String, value: String) -> Bool {
        keychain.set(value, forKey: key)
    }
    
    // 读取密码‌:ml-citation{ref="3,4" data="citationList"}
    static func getValue(key: String?) -> String? {
        guard let account = key else {
            return nil
        }
        return keychain.get(account)
    }
    
    // 删除记录‌:ml-citation{ref="3,4" data="citationList"}
    @discardableResult
    static func delete(key: String) -> Bool {
        keychain.delete(key)
    }
    
    @discardableResult
    static func deleteAll() -> Bool {
        keychain.clear()
    }
    
}
