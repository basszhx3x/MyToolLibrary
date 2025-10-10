import Foundation

public extension Date {
    /// 获取当前时间戳（毫秒）
    var timestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /// 格式化日期为字符串
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// 获取相对时间描述（如：刚刚、1分钟前、1小时前等）
    var relativeTime: String {
        let now = Date()
        let interval = now.timeIntervalSince(self)
        
        if interval < 60 {
            return "刚刚"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)分钟前"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)小时前"
        } else if interval < 2592000 {
            let days = Int(interval / 86400)
            return "\(days)天前"
        } else {
            return self.toString(format: "yyyy-MM-dd")
        }
    }
}