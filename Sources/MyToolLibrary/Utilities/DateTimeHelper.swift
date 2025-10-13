import Foundation

// MARK: - Date 扩展
public extension Date {
    /// 获取当前时间戳（毫秒）
    var timestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /// 格式化日期为字符串
    func formattedDate(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 格式化时间为字符串
    func formattedTime(format: String = "HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 格式化日期和时间为字符串
    func formattedDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 获取两个日期之间的天数差
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfOther = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfOther)
        return components.day ?? 0
    }
    
    /// 获取两个日期之间的小时差
    func hoursBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: date)
        return components.hour ?? 0
    }
    
    /// 获取两个日期之间的分钟差
    func minutesBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: date)
        return components.minute ?? 0
    }
    
    /// 获取两个日期之间的秒数差
    func secondsBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: date)
        return components.second ?? 0
    }
    
    /// 检查是否为今天
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// 检查是否为昨天
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// 检查是否为明天
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// 检查是否为本周
    var isThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// 检查是否为本月
    var isThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// 检查是否为本年
    var isThisYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// 添加指定的年份
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// 添加指定的月份
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// 添加指定的天数
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// 添加指定的小时数
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// 添加指定的分钟数
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    /// 添加指定的秒数
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    /// 获取当前日期的开始时间（00:00:00）
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// 获取当前日期的结束时间（23:59:59）
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    /// 获取当前月份的第一天
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取当前月份的最后一天
    var endOfMonth: Date {
        let calendar = Calendar.current
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: self.startOfMonth.addingMonths(1)) ?? self
    }
    
    /// 获取当前周的第一天
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取当前周的最后一天
    var endOfWeek: Date {
        let calendar = Calendar.current
        let components = DateComponents(day: 7, second: -1)
        return calendar.date(byAdding: components, to: self.startOfWeek) ?? self
    }
    
    /// 获取当前日期的年份
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// 获取当前日期的月份（1-12）
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// 获取当前日期的日期（1-31）
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// 获取当前日期的小时（0-23）
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// 获取当前日期的分钟（0-59）
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// 获取当前日期的秒数（0-59）
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// 获取当前日期的星期几（1-7，1表示周日）
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// 获取当前日期的季度（1-4）
    var quarter: Int {
        return (month - 1) / 3 + 1
    }
    
    /// 将日期转换为相对时间字符串（如：3分钟前，2小时前，1天前）
    var relativeTimeString: String {
        let now = Date()
        let seconds = now.secondsBetween(self)
        
        if seconds < 60 {
            return seconds == 1 ? "1秒前" : "\(seconds)秒前"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return minutes == 1 ? "1分钟前" : "\(minutes)分钟前"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return hours == 1 ? "1小时前" : "\(hours)小时前"
        } else if seconds < 604800 {
            let days = seconds / 86400
            return days == 1 ? "1天前" : "\(days)天前"
        } else if seconds < 2592000 {
            let weeks = seconds / 604800
            return weeks == 1 ? "1周前" : "\(weeks)周前"
        } else if seconds < 31536000 {
            let months = seconds / 2592000
            return months == 1 ? "1个月前" : "\(months)个月前"
        } else {
            let years = seconds / 31536000
            return years == 1 ? "1年前" : "\(years)年前"
        }
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
            return self.formattedDateTime(format: "yyyy-MM-dd")
        }
    }
    
    /// 判断日期是否在指定范围内
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return self >= startDate && self <= endDate
    }
    
    /// 计算年龄
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year ?? 0
    }
    
    /// 创建指定日期和时间的Date对象
    static func create(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)
    }
    
   
}
