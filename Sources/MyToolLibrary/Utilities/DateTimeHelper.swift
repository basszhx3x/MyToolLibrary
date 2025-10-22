import Foundation

// MARK: - Date 扩展
/// 为Date类型提供丰富的日期和时间处理功能
public extension Date {
    /// 获取当前时间戳（毫秒）
    /// 
    /// 从1970年1月1日00:00:00 UTC开始计算的毫秒数
    /// - Returns: 毫秒级时间戳
    var timestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /// 格式化日期为字符串
    /// 
    /// 使用指定的格式模式将日期转换为字符串
    /// - Parameter format: 日期格式模式，默认为"yyyy-MM-dd"
    /// - Returns: 格式化后的日期字符串
    func formattedDate(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 格式化时间为字符串
    /// 
    /// 使用指定的格式模式将时间转换为字符串
    /// - Parameter format: 时间格式模式，默认为"HH:mm:ss"
    /// - Returns: 格式化后的时间字符串
    func formattedTime(format: String = "HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 格式化日期和时间为字符串
    /// 
    /// 使用指定的格式模式将日期和时间转换为字符串
    /// - Parameter format: 日期时间格式模式，默认为"yyyy-MM-dd HH:mm:ss"
    /// - Returns: 格式化后的日期时间字符串
    func formattedDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 获取两个日期之间的天数差
    /// 
    /// 计算从当前日期到目标日期之间的整天数
    /// - Parameter date: 目标日期
    /// - Returns: 天数差，正数表示当前日期在目标日期之前，负数表示之后
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfOther = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfOther)
        return components.day ?? 0
    }
    
    /// 获取两个日期之间的小时差
    /// 
    /// 计算从当前日期到目标日期之间的小时数
    /// - Parameter date: 目标日期
    /// - Returns: 小时数差，正数表示当前日期在目标日期之前，负数表示之后
    func hoursBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: date)
        return components.hour ?? 0
    }
    
    /// 获取两个日期之间的分钟差
    /// 
    /// 计算从当前日期到目标日期之间的分钟数
    /// - Parameter date: 目标日期
    /// - Returns: 分钟数差，正数表示当前日期在目标日期之前，负数表示之后
    func minutesBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: date)
        return components.minute ?? 0
    }
    
    /// 获取两个日期之间的秒数差
    /// 
    /// 计算从当前日期到目标日期之间的秒数
    /// - Parameter date: 目标日期
    /// - Returns: 秒数差，正数表示当前日期在目标日期之前，负数表示之后
    func secondsBetween(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: date)
        return components.second ?? 0
    }
    
    /// 检查是否为今天
    /// 
    /// 判断当前日期是否是今天
    /// - Returns: 如果是今天则返回true，否则返回false
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// 检查是否为昨天
    /// 
    /// 判断当前日期是否是昨天
    /// - Returns: 如果是昨天则返回true，否则返回false
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// 检查是否为明天
    /// 
    /// 判断当前日期是否是明天
    /// - Returns: 如果是明天则返回true，否则返回false
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// 检查是否为本周
    /// 
    /// 判断当前日期是否与今天在同一周
    /// - Returns: 如果是本周则返回true，否则返回false
    var isThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// 检查是否为本月
    /// 
    /// 判断当前日期是否与今天在同一月
    /// - Returns: 如果是本月则返回true，否则返回false
    var isThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// 检查是否为本年
    /// 
    /// 判断当前日期是否与今天在同一年
    /// - Returns: 如果是本年则返回true，否则返回false
    var isThisYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// 添加指定的年份
    /// 
    /// 在当前日期基础上增加或减少指定的年数
    /// - Parameter years: 要添加的年数，可以为负数
    /// - Returns: 调整后的新日期
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// 添加指定的月份
    /// 
    /// 在当前日期基础上增加或减少指定的月数
    /// - Parameter months: 要添加的月数，可以为负数
    /// - Returns: 调整后的新日期
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// 添加指定的天数
    /// 
    /// 在当前日期基础上增加或减少指定的天数
    /// - Parameter days: 要添加的天数，可以为负数
    /// - Returns: 调整后的新日期
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// 添加指定的小时数
    /// 
    /// 在当前日期基础上增加或减少指定的小时数
    /// - Parameter hours: 要添加的小时数，可以为负数
    /// - Returns: 调整后的新日期
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// 添加指定的分钟数
    /// 
    /// 在当前日期基础上增加或减少指定的分钟数
    /// - Parameter minutes: 要添加的分钟数，可以为负数
    /// - Returns: 调整后的新日期
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    /// 添加指定的秒数
    /// 
    /// 在当前日期基础上增加或减少指定的秒数
    /// - Parameter seconds: 要添加的秒数，可以为负数
    /// - Returns: 调整后的新日期
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    /// 获取当前日期的开始时间（00:00:00）
    /// 
    /// 返回当前日期当天的开始时间
    /// - Returns: 当天的00:00:00时刻
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// 获取当前日期的结束时间（23:59:59）
    /// 
    /// 返回当前日期当天的结束时间
    /// - Returns: 当天的23:59:59时刻
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    /// 获取当前月份的第一天
    /// 
    /// 返回当前日期所在月份的第一天
    /// - Returns: 当月第一天的00:00:00时刻
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取当前月份的最后一天
    /// 
    /// 返回当前日期所在月份的最后一天
    /// - Returns: 当月最后一天的23:59:59时刻
    var endOfMonth: Date {
        let calendar = Calendar.current
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: self.startOfMonth.addingMonths(1)) ?? self
    }
    
    /// 获取当前周的第一天
    /// 
    /// 返回当前日期所在周的第一天（周日）
    /// - Returns: 当周第一天的00:00:00时刻
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取当前周的最后一天
    /// 
    /// 返回当前日期所在周的最后一天（周六）
    /// - Returns: 当周最后一天的23:59:59时刻
    var endOfWeek: Date {
        let calendar = Calendar.current
        let components = DateComponents(day: 7, second: -1)
        return calendar.date(byAdding: components, to: self.startOfWeek) ?? self
    }
    
    /// 获取当前日期的年份
    /// 
    /// - Returns: 4位数的年份
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// 获取当前日期的月份（1-12）
    /// 
    /// - Returns: 1到12之间的月份数
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// 获取当前日期的日期（1-31）
    /// 
    /// - Returns: 1到31之间的日期数
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// 获取当前日期的小时（0-23）
    /// 
    /// - Returns: 0到23之间的小时数
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// 获取当前日期的分钟（0-59）
    /// 
    /// - Returns: 0到59之间的分钟数
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// 获取当前日期的秒数（0-59）
    /// 
    /// - Returns: 0到59之间的秒数
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// 获取当前日期的星期几（1-7，1表示周日）
    /// 
    /// - Returns: 1到7之间的星期数，1表示周日，2表示周一，依此类推
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// 获取当前日期的季度（1-4）
    /// 
    /// 计算当前月份所在的季度
    /// - Returns: 1到4之间的季度数，1月-3月为第一季度，依此类推
    var quarter: Int {
        return (month - 1) / 3 + 1
    }
    
    /// 将日期转换为相对时间字符串（如：3分钟前，2小时前，1天前）
    /// 
    /// 根据与当前时间的差距，返回友好的相对时间描述
    /// - Returns: 相对时间描述字符串
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
    /// 
    /// 提供另一种风格的相对时间描述，更早的日期会显示具体日期
    /// - Returns: 相对时间描述字符串
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
    /// 
    /// 检查当前日期是否在开始日期和结束日期之间（包括边界）
    /// - Parameters:
    ///   - startDate: 范围的开始日期
    ///   - endDate: 范围的结束日期
    /// - Returns: 如果当前日期在范围内则返回true，否则返回false
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return self >= startDate && self <= endDate
    }
    
    /// 计算年龄
    /// 
    /// 根据当前日期计算从出生日期到现在的年龄
    /// - Returns: 计算得出的年龄
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year ?? 0
    }
    
    /// 创建指定日期和时间的Date对象
    /// 
    /// 根据提供的年、月、日、时、分、秒创建日期对象
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份（1-12）
    ///   - day: 日期（1-31）
    ///   - hour: 小时（0-23），默认为0
    ///   - minute: 分钟（0-59），默认为0
    ///   - second: 秒数（0-59），默认为0
    /// - Returns: 创建的Date对象，如果参数无效则返回nil
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
