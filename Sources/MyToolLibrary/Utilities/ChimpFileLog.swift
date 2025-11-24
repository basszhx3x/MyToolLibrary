//
//  ChimpFileLog.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import Foundation

/// 日志级别
public enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

/// 日志工具类，负责将日志写入文件的单例类
/// 
/// 提供多级别日志记录、按日期分文件存储和日志清理功能
public class ChimpFileLogger {
    /// 单例实例，全局共享的日志记录器
    public static let shared = ChimpFileLogger()
    
    /// 私有初始化方法，防止外部创建多个实例
    private init() {
        // 确保日志目录存在
        createLogDirectoryIfNeeded()
    }
    
    /// 日志文件存储目录路径
    /// 
    /// 在应用的Documents目录下创建Logs文件夹
    private var logDirectory: String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsDirectory + "/Logs"
    }
    
    /// 当前日志文件路径
    /// 
    /// 按日期命名日志文件，格式为"yyyy-MM-dd.log"
    private var logFilePath: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "\(dateFormatter.string(from: Date())).log"
        return logDirectory + "/" + fileName
    }
    
    /// 创建日志目录（如果不存在）
    /// 
    /// 在应用首次运行或日志目录被删除时自动创建
    private func createLogDirectoryIfNeeded() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: logDirectory) {
            do {
                try fileManager.createDirectory(atPath: logDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建日志目录失败: \(error.localizedDescription)")
            }
        }
    }
    
    /// 写入日志到文件
    /// - Parameters:
    ///   - message: 日志内容
    ///   - level: 日志级别
    ///   - file: 所在文件
    ///   - line: 所在行号
    /// 记录日志到文件
    /// 
    /// 自动添加时间戳、日志级别、文件位置等信息
    /// - Parameters:
    ///   - message: 日志内容
    ///   - level: 日志级别，默认为.debug
    ///   - file: 调用日志的文件路径，自动填充
    ///   - line: 调用日志的行号，自动填充
    public func log(_ message: String,
             level: LogLevel = .debug,
             file: String = #file,
             line: Int = #line) {
        
        // 获取文件名（去掉路径）
        let fileName = (file as NSString).lastPathComponent
        
        // 格式化日志时间，精确到毫秒
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timeString = timeFormatter.string(from: Date())
        
        // 构建结构化日志内容
        let logMessage = "[\(timeString)] [\(level.rawValue)] [\(fileName):\(line)] \(message)\n"
        
        // 追加写入到日志文件
        appendToFile(content: logMessage)
    }
    
    /// 追加内容到日志文件
    /// 
    /// 内部方法，处理日志内容的实际文件写入操作
    /// - Parameter content: 要写入的日志内容字符串
    private func appendToFile(content: String) {
        // 将字符串转换为数据
        guard let data = content.data(using: .utf8) else {
            print("日志内容转换为数据失败")
            return
        }
        
        let fileManager = FileManager.default
        let filePath = logFilePath
        
        // 如果文件不存在则创建，存在则追加到文件末尾
        if fileManager.fileExists(atPath: filePath) {
            // 尝试打开文件并追加内容
            if let fileHandle = try? FileHandle(forWritingTo: URL(fileURLWithPath: filePath)) {
                fileHandle.seekToEndOfFile() // 移动到文件末尾
                fileHandle.write(data)      // 写入数据
                fileHandle.closeFile()      // 关闭文件
            } else {
                // 如果无法打开现有文件，则覆盖写入
                try? data.write(to: URL(fileURLWithPath: filePath))
            }
        } else {
            // 文件不存在，创建新文件
            try? data.write(to: URL(fileURLWithPath: filePath))
        }
    }
    
    /// 获取所有日志文件路径列表
    /// 
    /// - Returns: 所有.log日志文件的完整路径数组
    public func getAllLogFiles() -> [String] {
        do {
            // 获取日志目录中的所有.log文件
            return try FileManager.default.contentsOfDirectory(atPath: logDirectory)
                .filter { $0.hasSuffix(".log") } // 筛选.log文件
                .map { logDirectory + "/" + $0 }  // 拼接完整路径
        } catch {
            print("获取日志文件列表失败: \(error.localizedDescription)")
            return [] // 发生错误时返回空数组
        }
    }
    
    /// 清除指定日期之前的日志文件
    /// 
    /// 用于定期清理旧日志，节省存储空间
    /// - Parameter date: 截止日期，早于此日期的日志将被删除
    public func cleanLogs(before date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 与日志文件命名格式保持一致
        
        // 获取所有日志文件
        let logFiles = getAllLogFiles()
        // 格式化目标日期为字符串
        let targetDateString = dateFormatter.string(from: date)
        
        // 遍历所有日志文件
        for file in logFiles {
            // 提取文件名中的日期部分
            let fileName = (file as NSString).lastPathComponent
            let fileDateString = fileName.replacingOccurrences(of: ".log", with: "")
            
            // 比较日期，删除早于目标日期的日志
            if fileDateString < targetDateString {
                try? FileManager.default.removeItem(atPath: file)
            }
        }
    }
}

// 使用示例
/*
// 打印不同级别的日志
FileLogger.shared.log("应用启动", level: .info)
FileLogger.shared.log("用户登录成功: userId=123", level: .debug)
FileLogger.shared.log("网络请求超时", level: .warning)
FileLogger.shared.log("数据库连接失败", level: .error)

// 清除7天前的日志
if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
    FileLogger.shared.cleanLogs(before: sevenDaysAgo)
}
*/
    

