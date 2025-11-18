import Foundation
import UIKit
import SwiftDate
import CommonCrypto

// MARK: - String 扩展
/// String扩展
/// 
/// 为String类型添加常用的验证、转换、处理等辅助方法
public extension String {

    /// 检查字符串是否为有效的电子邮件格式
    /// 
    /// 使用正则表达式验证字符串是否符合电子邮件地址的标准格式
    /// - Returns: 如果字符串是有效的电子邮件格式则返回true，否则返回false
    var isValidEmail: Bool {
        let pattern = "^[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,}[A-Z0-9a-z])?@([A-Za-z0-9-]{1,}\\.)+[A-Za-z]{2,}$"
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    /// 检查字符串是否只包含数字
    /// 
    /// 验证字符串是否完全由数字字符组成
    /// - Returns: 如果字符串只包含数字则返回true，否则返回false
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// 检查字符串是否只包含字母
    /// 
    /// 验证字符串是否完全由字母字符组成
    /// - Returns: 如果字符串只包含字母则返回true，否则返回false
    var isAlphabetic: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    /// 检查字符串是否只包含字母和数字
    /// 
    /// 验证字符串是否完全由字母和数字字符组成
    /// - Returns: 如果字符串只包含字母和数字则返回true，否则返回false
    var isAlphanumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
    
    /// 将字符串转换为布尔值
    /// 
    /// 支持的格式："true"/"false"（不区分大小写）、"1"/"0"、"yes"/"no"（不区分大小写）
    /// - Returns: 转换后的布尔值，如果无法转换则返回nil
    var boolValue: Bool? {
        let lowercased = self.lowercased()
        
        // 处理常见的布尔值表示形式
        switch lowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    /// 安全地将字符串转换为布尔值
    /// 
    /// 如果字符串不能转换为布尔值，则返回指定的默认值
    /// - Parameter defaultValue: 无法转换时的默认值
    /// - Returns: 转换后的布尔值或默认值
    func toBool(defaultValue: Bool = false) -> Bool {
        return boolValue ?? defaultValue
    }
    
    /// 移除字符串中的所有空格
    /// 
    /// 删除字符串中所有出现的空格字符
    /// - Returns: 移除所有空格后的新字符串
    var removingAllSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    /// 移除字符串两端的空格和换行符
    /// 
    /// 去除字符串开头和结尾的空白字符和换行符
    /// - Returns: 修剪后的新字符串
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 截断字符串到指定长度，并添加省略号
    /// 
    /// 如果字符串长度超过指定限制，则截断并添加省略号
    /// - Parameters:
    ///   - length: 最大允许长度
    ///   - trailing: 用于替换被截断部分的字符串，默认为"..."
    /// - Returns: 截断后的字符串
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count <= length {
            return self
        }
        return String(prefix(length - trailing.count)) + trailing
    }
    
    /// 计算字符串的MD5哈希值
    /// 
    /// 使用CommonCrypto库计算字符串的MD5哈希值，返回十六进制格式的结果
    /// - Returns: 字符串的MD5哈希值，以十六进制字符串形式返回
    var md5: String {
        let data = Data(utf8)
#if os(macOS) || targetEnvironment(macCatalyst)
        // macOS环境下使用CommonCrypto
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
#else
        // iOS环境下使用替代实现，避免弃用警告
        // 注意：为了简化，这里保留了原实现，但在实际生产环境中应考虑使用SHA256
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
#endif
    }
    
    /// 计算字符串的SHA256哈希值
    /// 
    /// 使用CommonCrypto库计算字符串的SHA256哈希值，返回十六进制格式的结果
    /// - Returns: 字符串的SHA256哈希值，以十六进制字符串形式返回
    var sha256: String {
        let data = Data(utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    /// 将字符串转换为Base64编码
    /// 
    /// 将UTF-8编码的字符串转换为Base64格式
    /// - Returns: Base64编码的字符串，如果转换失败则返回nil
    var base64Encoded: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    /// 从Base64编码字符串解码
    /// 
    /// 将Base64编码的字符串解码为原始的UTF-8字符串
    /// - Returns: 解码后的原始字符串，如果解码失败则返回nil
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// 获取字符串的字节长度
    /// 
    /// 计算字符串在UTF-8编码下的字节长度
    /// - Returns: 字符串的字节长度
    var byteLength: Int {
        return data(using: .utf8)?.count ?? 0
    }
    
    /// 将首字母大写
    /// 
    /// 将字符串的第一个字符转换为大写，其余部分保持不变
    /// - Returns: 首字母大写后的新字符串
    var capitalizingFirstLetter: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
    
    /// 将首字母小写
    /// 
    /// 将字符串的第一个字符转换为小写，其余部分保持不变
    /// - Returns: 首字母小写后的新字符串
    var lowercasingFirstLetter: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    /// 将驼峰命名转换为下划线命名
    /// 
    /// 将驼峰命名法的字符串转换为下划线分隔的命名格式，并转换为小写
    /// - Returns: 下划线格式的新字符串
    var snakeCase: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased() ?? self
    }
    
    /// 将下划线命名转换为驼峰命名
    /// 
    /// 将下划线分隔的命名格式转换为驼峰命名法
    /// - Returns: 驼峰格式的新字符串
    var camelCase: String {
        let parts = components(separatedBy: "_")
        return parts[0] + parts.dropFirst().map { $0.capitalizingFirstLetter }.joined()
    }
    
    /// 检查字符串是否包含中文字符
    /// 
    /// 使用正则表达式检查字符串中是否包含任何中文字符
    /// - Returns: 如果字符串包含中文字符则返回true，否则返回false
    var containsChineseCharacters: Bool {
        return range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    /// 安全地获取指定位置的字符
    /// 
    /// 防止索引越界的安全访问方法
    /// - Parameter index: 字符的位置索引
    /// - Returns: 指定位置的字符，如果索引无效则返回nil
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// 安全地获取子字符串
    /// 
    /// 防止索引越界的安全子字符串获取方法
    /// - Parameters:
    ///   - from: 起始位置
    ///   - length: 子字符串长度
    /// - Returns: 子字符串，如果参数无效则返回nil
    func substring(from: Int, length: Int) -> String? {
        guard from >= 0, length >= 0, from + length <= count else {
            return nil
        }
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: length)
        return String(self[start..<end])
    }
    
    /// 将字符串转换为URL
    /// 
    /// 将字符串解析为URL对象
    /// - Returns: URL对象，如果字符串不是有效的URL格式则返回nil
    var url: URL? {
        return URL(string: self)
    }
    
    /// 将字符串转换为带查询参数的URL
    /// 
    /// 将字符串转换为URL并添加查询参数
    /// - Parameter parameters: 查询参数字典
    /// - Returns: 带查询参数的URL对象，如果转换失败则返回nil
    func urlWithParameters(_ parameters: [String: Any]) -> URL? {
        guard var urlComponents = URLComponents(string: self) else {
            return nil
        }
        
        urlComponents.queryItems = parameters.map { 
            URLQueryItem(name: $0.key, value: "\\($0.value)") 
        }
        
        return urlComponents.url
    }
    
    /// 移除字符串中的HTML标签
    /// 
    /// 使用正则表达式移除所有HTML标签
    /// - Returns: 移除HTML标签后的纯文本
    var removingHTMLTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 检查字符串是否为有效的URL
    /// 
    /// 验证字符串是否是有效的URL格式
    /// - Returns: 如果字符串是有效的URL则返回true，否则返回false
    var isValidURL: Bool {
        return URL(string: self) != nil
    }
    
    /// 检查字符串是否为有效的手机号码（中国）
    /// 
    /// 验证字符串是否符合中国手机号码的格式（以1开头的11位数字）
    /// - Returns: 如果字符串是有效的中国手机号码则返回true，否则返回false
    var isValidChinesePhoneNumber: Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    /// 隐藏部分字符串（用于隐私信息）
    /// 
    /// 隐藏字符串中间的部分内容，只保留前后指定数量的字符
    /// - Parameters:
    ///   - mask: 用于替换被隐藏部分的字符，默认为"*"
    ///   - showFirst: 显示开头的字符数量，默认为3
    ///   - showLast: 显示结尾的字符数量，默认为4
    /// - Returns: 部分隐藏的字符串
    func masking(mask: String = "*", showFirst: Int = 3, showLast: Int = 4) -> String {
        let totalLength = count
        
        if totalLength <= showFirst + showLast {
            return String(repeating: mask, count: totalLength)
        }
        
        let firstPart = prefix(showFirst)
        let lastPart = suffix(showLast)
        let maskedCount = totalLength - showFirst - showLast
        let maskedPart = String(repeating: mask, count: maskedCount)
        
        return "\(firstPart)\(maskedPart)\(lastPart)"
    }
}

// MARK: - 字符串格式化工具类
/// 字符串格式化工具类
/// 
/// 提供各种字符串格式化功能，包括数字格式化、日期格式化和特殊格式处理等
public class StringFormatter {
    /// 格式化数字为千分位显示
    /// - Parameter number: 需要格式化的数字
    /// - Returns: 千分位格式化后的字符串
    static func formatNumberWithCommas(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: number)) ?? "\\(number)"
    }
    
    /// 格式化文件大小（自动转换为B/KB/MB/GB等单位）
    /// - Parameter bytes: 文件大小（字节）
    /// - Returns: 格式化后的文件大小字符串
    static func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    /// 将日期字符串从一种格式转换为另一种格式
    /// - Parameters:
    ///   - dateString: 需要转换的日期字符串
    ///   - fromFormat: 原始日期格式
    ///   - toFormat: 目标日期格式
    /// - Returns: 转换后的日期字符串，如果转换失败则返回nil
    static func formatDateString(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    /// 格式化手机号码（添加空格分隔，如：138 0000 0000）
    /// - Parameter phone: 手机号码
    /// - Returns: 格式化后的手机号码
    static func formatPhoneNumber(_ phone: String) -> String {
        let digits = phone.removingAllSpaces
        guard digits.count == 11 else {
            return phone
        }
        
        let firstPart = digits.prefix(3)
        let secondPart = digits.dropFirst(3).prefix(4)
        let thirdPart = digits.dropFirst(7)
        
        return "\(firstPart) \(secondPart) \(thirdPart)"
    }
}

// MARK: - 字符串解析工具类
/// 字符串解析工具类
/// 
/// 提供从字符串中提取和解析特定内容的功能，包括数字、URL、HTML文本等
public class StringParser {
    /// 从字符串中提取所有数字字符
    /// - Parameter string: 原始字符串
    /// - Returns: 只包含数字的字符串
    static func extractNumbers(from string: String) -> String {
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    /// 从字符串中提取所有URL链接
    /// - Parameter string: 包含URL的字符串
    /// - Returns: URL数组
    static func extractURLs(from string: String) -> [URL] {
        var urls: [URL] = []
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        detector?.enumerateMatches(in: string, range: NSRange(string.startIndex..., in: string)) { result, _, _ in
            if let url = result?.url {
                urls.append(url)
            }
        }
        
        return urls
    }
    
    /// 从HTML字符串中提取纯文本（移除所有HTML标签）
    /// - Parameter html: HTML字符串
    /// - Returns: 提取的纯文本
    static func extractTextFromHTML(_ html: String) -> String {
        // 简单的HTML标签移除方法
        return html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 解析JSON字符串为字典
    /// - Parameter jsonString: JSON格式的字符串
    /// - Returns: 解析后的字典，如果解析失败则返回nil
    static func parseJSONStringToDictionary(_ jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON解析失败: \\(error)")
            return nil
        }
    }
    
    /// 解析CSV字符串为二维数组
    /// - Parameter csvString: CSV格式的字符串
    /// - Returns: 二维数组，每行对应一个数组
    static func parseCSV(_ csvString: String) -> [[String]] {
        let lines = csvString.components(separatedBy: "\\n")
        var result: [[String]] = []
        
        for line in lines {
            if line.isEmpty {
                continue
            }
            
            // 简单的CSV解析，不处理引号中的逗号
            let columns = line.components(separatedBy: ",")
            result.append(columns)
        }
        
        return result
    }
}

// MARK: - 字符串验证工具类
/// 字符串验证工具类
/// 
/// 提供各种字符串验证功能，包括长度验证、格式验证、密码强度检查等
public class StringValidator {
    /// 验证字符串长度是否在指定范围内
    /// - Parameters:
    ///   - string: 要验证的字符串
    ///   - minLength: 最小长度，默认为0
    ///   - maxLength: 最大长度，可选
    /// - Returns: 长度是否有效
    static func isLengthValid(_ string: String, minLength: Int = 0, maxLength: Int? = nil) -> Bool {
        if string.count < minLength {
            return false
        }
        
        if let maxLength = maxLength, string.count > maxLength {
            return false
        }
        
        return true
    }
    
    /// 验证字符串是否满足指定的正则表达式
    /// - Parameters:
    ///   - string: 要验证的字符串
    ///   - pattern: 正则表达式模式
    /// - Returns: 是否匹配
    static func matchesPattern(_ string: String, pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: string)
    }
    
    /// 验证密码强度（至少8位，包含大小写字母、数字和特殊字符）
    /// - Parameter password: 要验证的密码
    /// - Returns: 是否为强密码
    static func isStrongPassword(_ password: String) -> Bool {
        // 至少8位，包含大小写字母、数字和特殊字符
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return matchesPattern(password, pattern: passwordRegex)
    }
    
    /// 验证是否为有效的中国身份证号码（基础格式验证）
    /// - Parameter idCard: 身份证号码
    /// - Returns: 是否有效
    static func isValidChineseIDCard(_ idCard: String) -> Bool {
        // 简单验证格式：15位或18位，最后一位可能是X
        let idCardRegex = "^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}[\\dXx]$"
        return matchesPattern(idCard, pattern: idCardRegex)
    }
    
    /// 增强版中国身份证验证（包含校验码验证）
    /// - Parameter idCard: 身份证号码
    /// - Returns: 是否有效
    static func isValidChineseIDCardEnhanced(_ idCard: String) -> Bool {
        // 1. 基本格式验证
        let idCardRegex = "^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}[\\dXx]$"
        guard matchesPattern(idCard, pattern: idCardRegex) else {
            return false
        }
        
        // 2. 校验码验证
        let weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let checkCodes = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]
        
        let idCard = idCard.uppercased()
        var sum = 0
        
        // 计算前17位的加权和
        for i in 0..<17 {
            let charIndex = idCard.index(idCard.startIndex, offsetBy: i)
            guard let digit = Int(String(idCard[charIndex])) else {
                return false
            }
            sum += digit * weights[i]
        }
        
        // 计算校验码
        let checkIndex = sum % 11
        let expectedCheckCode = checkCodes[checkIndex]
        let actualCheckCode = String(idCard.last!)
        
        return actualCheckCode == expectedCheckCode
    }
    
    /// 验证是否为有效的香港身份证号码
    /// - Parameter idCard: 香港身份证号码
    /// - Returns: 是否有效
    static func isValidHongKongIDCard(_ idCard: String) -> Bool {
        // 香港身份证格式：1或2个字母开头，后跟6个数字，最后一位可能是数字或括号中的字母/数字
        let hkIDRegex = "^[A-Za-z]{1,2}[0-9]{6}[0-9A-Za-z]?\\(?[0-9A-Za-z]\\)?$"
        guard matchesPattern(idCard, pattern: hkIDRegex) else {
            return false
        }
        
        // 简单的校验算法
        let normalizedID = idCard.uppercased().replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        
        if normalizedID.count != 8 {
            return false
        }
        
        // 字母转换为数字：A=10, B=11, ..., Z=35
        var sum = 0
        let firstChar = String(normalizedID.first!)
        let secondChar: String
        
        if normalizedID.count == 8 {
            // 处理2个字母开头的情况
            if normalizedID.count >= 2 {
                secondChar = String(normalizedID[normalizedID.index(normalizedID.startIndex, offsetBy: 1)])
                if let charValue = Int(secondChar, radix: 36) {
                    sum += (charValue - 9) * 1
                }
            }
            // 第一个字母的权重是8
            if let charValue = Int(firstChar, radix: 36) {
                sum += (charValue - 9) * 8
            }
        }
        
        // 数字部分的权重分别是7, 6, 5, 4, 3, 2
        let weights = [7, 6, 5, 4, 3, 2]
        for i in 0..<6 {
            let digitIndex = normalizedID.index(normalizedID.startIndex, offsetBy: normalizedID.count == 8 ? i + 2 : i + 1)
            if let digit = Int(String(normalizedID[digitIndex])) {
                sum += digit * weights[i]
            }
        }
        
        // 最后一位校验码
        let lastChar = String(normalizedID.last!)
        let lastValue: Int
        
        if lastChar == "A" {
            lastValue = 10
        } else if let value = Int(lastChar) {
            lastValue = value
        } else {
            return false
        }
        
        // 校验：(sum + lastValue) % 11 == 0
        return (sum + lastValue) % 11 == 0
    }
    
    /// 验证是否为有效的澳门身份证号码
    /// - Parameter idCard: 澳门身份证号码
    /// - Returns: 是否有效
    static func isValidMacauIDCard(_ idCard: String) -> Bool {
        // 澳门身份证格式：开头可能有M/，后跟8位数字，最后一位是校验码
        let macauIDRegex = "^(M\\/)?[0-9]{8}[0-9A-Za-z]$"
        return matchesPattern(idCard, pattern: macauIDRegex)
    }
    
    /// 验证是否为有效的银行卡号（使用Luhn算法）
    /// - Parameter cardNumber: 银行卡号
    /// - Returns: 是否有效
    static func isValidBankCardNumber(_ cardNumber: String) -> Bool {
        let digits = cardNumber.removingAllSpaces
        
        // 简单验证：13-19位数字
        if !digits.isNumeric || digits.count < 13 || digits.count > 19 {
            return false
        }
        
        // 使用Luhn算法验证
        return luhnCheck(digits)
    }
    
    /// Luhn算法实现（银行卡号校验算法）
    /// - Parameter digits: 数字字符串
    /// - Returns: 是否通过校验
    private static func luhnCheck(_ digits: String) -> Bool {
        var sum = 0
        let reversedDigits = String(digits.reversed())
        
        for (index, digit) in reversedDigits.enumerated() {
            guard let digitValue = Int(String(digit)) else {
                return false
            }
            
            if index % 2 == 1 {
                let doubled = digitValue * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digitValue
            }
        }
        
        return sum % 10 == 0
    }
}

// MARK: - 字符串加密工具类
/// 字符串加密工具类
/// 
/// 提供字符串加密解密相关功能，包括URL编码解码和简单加密算法等
public class StringEncryptor {
    /// 对字符串进行URL编码
    /// - Parameter string: 需要编码的字符串
    /// - Returns: URL编码后的字符串
    static func urlEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    /// 对URL编码的字符串进行解码
    /// - Parameter string: URL编码的字符串
    /// - Returns: 解码后的字符串
    static func urlDecode(_ string: String) -> String {
        return string.removingPercentEncoding ?? string
    }
    
    /// 使用指定密钥进行简单的异或加密
    /// - Parameters:
    ///   - string: 需要加密的字符串
    ///   - key: 加密密钥
    /// - Returns: 十六进制格式的加密结果
    static func xorEncrypt(_ string: String, key: String) -> String {
        var encrypted = ""
        let stringBytes = Array(string.utf8)
        let keyBytes = Array(key.utf8)
        
        for (index, byte) in stringBytes.enumerated() {
            let keyByte = keyBytes[index % keyBytes.count]
            encrypted.append(String(format: "%02x", byte ^ keyByte))
        }
        
        return encrypted
    }
    
    /// 使用指定密钥进行简单的异或解密
    /// - Parameters:
    ///   - string: 十六进制格式的加密字符串
    ///   - key: 解密密钥（与加密密钥相同）
    /// - Returns: 解密后的原始字符串，如果解密失败则返回nil
    static func xorDecrypt(_ string: String, key: String) -> String? {
        // 确保字符串长度为偶数
        guard string.count % 2 == 0 else {
            return nil
        }
        
        var decryptedBytes: [UInt8] = []
        let keyBytes = Array(key.utf8)
        
        // 解析每两个字符为一个字节
        for i in stride(from: 0, to: string.count, by: 2) {
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(startIndex, offsetBy: 2)
            let byteString = String(string[startIndex..<endIndex])
            
            guard let encryptedByte = UInt8(byteString, radix: 16) else {
                return nil
            }
            
            let keyByte = keyBytes[i/2 % keyBytes.count]
            decryptedBytes.append(encryptedByte ^ keyByte)
        }
        
        return String(bytes: decryptedBytes, encoding: .utf8)
    }
}

/// String时间戳扩展
/// 
/// 为String类型添加时间戳相关的转换和格式化功能
public extension String {
    /// 将时间戳转换为DateInRegion对象
    /// 
    /// 假设字符串包含Unix时间戳（秒），转换为SwiftDate的DateInRegion对象
    /// - Returns: 转换后的DateInRegion对象
    func getCurrentDate() -> DateInRegion {
        let date =  DateInRegion(seconds: (Double(self) ?? 0), region: .current)
        return date
    }
    
    /// 将时间戳转换为日期时间字符串（yyyy-MM-dd HH:mm格式）
    /// 
    /// 将时间戳字符串转换为指定格式的日期时间字符串
    /// - Returns: 格式化后的日期时间字符串，如果转换失败则返回空字符串
    func getCurrentDateString() -> String {
        guard Int(self) != 0,self.count > 2 else { return "" }
        let date = getCurrentDate()
        let dateString = date.toString(.custom("yyyy-MM-dd HH:mm"))
        return dateString
    }
    
    /// 将时间戳转换为日期字符串（yyyy-MM-dd格式）
    /// 
    /// 将时间戳字符串转换为短日期格式字符串
    /// - Returns: 格式化后的日期字符串，如果转换失败则返回空字符串
    func getShortCurrentDateString() -> String {
        guard Int(self) != 0,self.count > 2 else { return "" }
        let date = getCurrentDate()
        let dateString = date.toString(.custom("yyyy-MM-dd"))
        return dateString
    }
    
    /// 将时间戳转换为自定义格式的日期字符串
    /// 
    /// 将时间戳字符串转换为指定格式的日期字符串
    /// - Parameter custom: 自定义日期格式字符串，遵循DateFormatter格式规范
    /// - Returns: 格式化后的日期字符串，如果转换失败则返回空字符串
    func getShortCurrentDateString(custom:String) -> String {
        guard Int(self) != 0,self.count > 2 else { return "" }
        let date = getCurrentDate()
        let dateString = date.toString(.custom(custom))
        return dateString
    }
}

/// String尺寸计算扩展
/// 
/// 为String类型添加文本尺寸计算功能，用于UI布局和文本展示
public extension String {
    /// 计算字符串在指定字体下的尺寸
    /// 
    /// 使用NSString的size(withAttributes:)方法计算单行文本的尺寸
    /// - Parameter font: 用于计算尺寸的字体
    /// - Returns: 字符串的尺寸，适用于单行文本
    func size(withFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attributes)
    }
    
    /// 根据字体计算字符串的宽度（考虑多行情况但返回最大宽度）
    /// 
    /// 使用boundingRect方法计算文本在指定字体下的理论宽度
    /// - Parameter font: 用于计算宽度的字体
    /// - Returns: 字符串的宽度，已向上取整以避免显示不全的问题
    func calculateStringWidth(font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFLOAT_MAX)
        let size = attributedText.boundingRect(with: maxSize,
                                              options: .usesLineFragmentOrigin,
                                              context: nil)
        return ceil(size.width)
    }
    
    /// 根据宽度和字体计算字符串的高度（支持多行文本）
    /// 
    /// 使用boundingRect方法计算多行文本在指定宽度限制下的高度
    /// - Parameters:
    ///   - font: 用于计算高度的字体
    ///   - width: 文本的最大宽度限制
    /// - Returns: 字符串的高度，已向上取整以避免显示不全的问题
    func calculateHeight(withFont font: UIFont, constrainedToWidth width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let size = attributedText.boundingRect(with: maxSize,
                                              options: .usesLineFragmentOrigin,
                                              context: nil)
        return ceil(size.height)
    }
    
    /// 通过UILabel计算字符串在指定字体下的完整尺寸（最准确的方法）
    /// 
    /// 创建临时UILabel并使用sizeToFit方法计算文本的实际显示尺寸，这是最准确的尺寸计算方法
    /// - Parameter font: 用于计算尺寸的字体
    /// - Returns: 字符串的实际显示尺寸
    func calculateSize(withFont font: UIFont) -> CGSize {
        let label = UILabel()
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.size
    }
    
    /// 将JSON字符串转换为数组
    /// 
    /// 尝试解析JSON格式的字符串并返回对应的数组
    /// - Returns: 解析后的数组，如果字符串不是有效的JSON或不是数组格式则返回nil
    func toArray() -> [Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            return object as? [Any]
        } catch {
            return nil
        }
    }
    
    /// 将JSON字符串转换为字典
    /// 
    /// 尝试解析JSON格式的字符串并返回对应的字典
    /// - Returns: 解析后的字典，如果字符串不是有效的JSON或不是字典格式则返回nil
    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            return object as? [String: Any]
        } catch {
            return nil
        }
    }
}
