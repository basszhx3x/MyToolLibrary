//
//  Print+Extensions.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import Foundation

/// 在DEBUG模式下打印带时间戳的日志信息
/// - Parameters:
///   - items: 要打印的内容，可接受多个参数
///   - separator: 多个参数之间的分隔符，默认为空格
///   - terminator: 打印结束符，默认为换行符
public func printLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    // 获取当前时间
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.nanosecond], from: currentDate)
    
    // 计算毫秒时间戳（将纳秒转换为毫秒）
    let nanosecond = components.nanosecond ?? 0
    let milliseconds = nanosecond/1000000
    let paddedNumber = String(format: "%03d", milliseconds)
    
    // 格式化日期时间
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
    let time = dateformatter.string(from: currentDate)
    
    // 打印带时间戳的日志
    print("\(time) \(paddedNumber)：", terminator: "")
    print(items, separator: separator, terminator: terminator)
#else
    // Release模式下不打印日志
#endif
}
