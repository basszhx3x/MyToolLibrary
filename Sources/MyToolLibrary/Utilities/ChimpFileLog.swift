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

/// 日志工具类，负责将日志写入文件
public class IgatherFileLogger {
    // 单例实例
    public static let shared = IgatherFileLogger()
    private init() {
        // 确保日志目录存在
        createLogDirectoryIfNeeded()
    }
    
    // 日志目录路径
    private var logDirectory: String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsDirectory + "/Logs"
    }
    
    // 日志文件路径（按日期命名）
    private var logFilePath: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "\(dateFormatter.string(from: Date())).log"
        return logDirectory + "/" + fileName
    }
    
    /// 创建日志目录（如果不存在）
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
   public func log(_ message: String,
             level: LogLevel = .debug,
             file: String = #file,
             line: Int = #line) {
        
        // 获取文件名（去掉路径）
        let fileName = (file as NSString).lastPathComponent
        
        // 格式化日志时间
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timeString = timeFormatter.string(from: Date())
        
        // 构建日志内容
        let logMessage = "[\(timeString)] [\(level.rawValue)] [\(fileName):\(line)] \(message)\n"
        
        // 写入文件
        appendToFile(content: logMessage)
    }
    
    /// 追加内容到日志文件
    private func appendToFile(content: String) {
        guard let data = content.data(using: .utf8) else {
            print("日志内容转换为数据失败")
            return
        }
        
        let fileManager = FileManager.default
        let filePath = logFilePath
        
        // 如果文件不存在则创建，存在则追加
        if fileManager.fileExists(atPath: filePath) {
            if let fileHandle = try? FileHandle(forWritingTo: URL(fileURLWithPath: filePath)) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                try? data.write(to: URL(fileURLWithPath: filePath))
            }
        } else {
            try? data.write(to: URL(fileURLWithPath: filePath))
        }
    }
    
    /// 获取所有日志文件路径
    public func getAllLogFiles() -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: logDirectory)
                .filter { $0.hasSuffix(".log") }
                .map { logDirectory + "/" + $0 }
        } catch {
            print("获取日志文件列表失败: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 清除指定日期之前的日志
    public func cleanLogs(before date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let logFiles = getAllLogFiles()
        let targetDateString = dateFormatter.string(from: date)
        
        for file in logFiles {
            let fileName = (file as NSString).lastPathComponent
            let fileDateString = fileName.replacingOccurrences(of: ".log", with: "")
            
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
    

