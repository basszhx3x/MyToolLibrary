//
//  Print+Extensions.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import Foundation

public func printLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.nanosecond], from: currentDate)
    let nanosecond = components.nanosecond ?? 000
    // 由于 DateComponents 的 nanosecond 是以纳秒为单位，我们需要将其转换为毫秒
    let milliseconds = nanosecond/1000000
    let paddedNumber = String(format: "%03d", milliseconds)
    
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
    let time = dateformatter.string(from: currentDate)
    
    print("\(time) \(paddedNumber)：", terminator: "")
    print(items, separator: separator, terminator: terminator)
    //    print("当前是Debug模式")
#else
    //    print("当前不是Debug模式")
#endif
}
