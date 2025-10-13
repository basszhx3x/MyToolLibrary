import Foundation
// 导入CommonCrypto以支持哈希功能
import CommonCrypto
// MARK: - String 扩展
public extension String {

    /// 检查字符串是否为有效的电子邮件格式
    var isValidEmail: Bool {
        let pattern = "^[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,}[A-Z0-9a-z])?@([A-Za-z0-9-]{1,}\\.)+[A-Za-z]{2,}$"
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    /// 检查字符串是否只包含数字
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// 检查字符串是否只包含字母
    var isAlphabetic: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    /// 检查字符串是否只包含字母和数字
    var isAlphanumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
    
    /// 移除字符串中的所有空格
    var removingAllSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    /// 移除字符串两端的空格和换行符
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 截断字符串到指定长度，并添加省略号
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count <= length {
            return self
        }
        return String(prefix(length - trailing.count)) + trailing
    }
    
    /// 计算字符串的MD5哈希值
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
    var base64Encoded: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    /// 从Base64编码字符串解码
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// 获取字符串的字节长度
    var byteLength: Int {
        return data(using: .utf8)?.count ?? 0
    }
    
    /// 将首字母大写
    var capitalizingFirstLetter: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
    
    /// 将首字母小写
    var lowercasingFirstLetter: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    /// 将驼峰命名转换为下划线命名
    var snakeCase: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased() ?? self
    }
    
    /// 将下划线命名转换为驼峰命名
    var camelCase: String {
        let parts = components(separatedBy: "_")
        return parts[0] + parts.dropFirst().map { $0.capitalizingFirstLetter }.joined()
    }
    
    /// 检查字符串是否包含中文字符
    var containsChineseCharacters: Bool {
        return range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    /// 安全地获取指定位置的字符
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// 安全地获取子字符串
    func substring(from: Int, length: Int) -> String? {
        guard from >= 0, length >= 0, from + length <= count else {
            return nil
        }
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: length)
        return String(self[start..<end])
    }
    
    /// 将字符串转换为URL
    var url: URL? {
        return URL(string: self)
    }
    
    /// 将字符串转换为带查询参数的URL
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
    var removingHTMLTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 检查字符串是否为有效的URL
    var isValidURL: Bool {
        return URL(string: self) != nil
    }
    
    /// 检查字符串是否为有效的手机号码（中国）
    var isValidChinesePhoneNumber: Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    /// 隐藏部分字符串（用于隐私信息）
    func masking(mask: String = "*", showFirst: Int = 3, showLast: Int = 4) -> String {
        let totalLength = count
        
        if totalLength <= showFirst + showLast {
            return String(repeating: mask, count: totalLength)
        }
        
        let firstPart = prefix(showFirst)
        let lastPart = suffix(showLast)
        let maskedCount = totalLength - showFirst - showLast
        let maskedPart = String(repeating: mask, count: maskedCount)
        
        return "\\(firstPart)\\(maskedPart)\\(lastPart)"
    }
}

// MARK: - 字符串格式化工具类
public class StringFormatter {
    /// 格式化数字为千分位
    static func formatNumberWithCommas(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: number)) ?? "\\(number)"
    }
    
    /// 格式化文件大小
    static func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    /// 格式化日期字符串
    static func formatDateString(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    /// 格式化手机号码（添加空格分隔）
    static func formatPhoneNumber(_ phone: String) -> String {
        let digits = phone.removingAllSpaces
        guard digits.count == 11 else {
            return phone
        }
        
        let firstPart = digits.prefix(3)
        let secondPart = digits.dropFirst(3).prefix(4)
        let thirdPart = digits.dropFirst(7)
        
        return "\\(firstPart) \\(secondPart) \\(thirdPart)"
    }
}

// MARK: - 字符串解析工具类
public class StringParser {
    /// 从字符串中提取所有数字
    static func extractNumbers(from string: String) -> String {
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    /// 从字符串中提取URLs
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
    
    /// 从HTML字符串中提取文本
    static func extractTextFromHTML(_ html: String) -> String {
        // 简单的HTML标签移除方法
        return html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 解析JSON字符串为字典
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
public class StringValidator {
    /// 验证字符串长度是否在指定范围内
    static func isLengthValid(_ string: String, minLength: Int = 0, maxLength: Int? = nil) -> Bool {
        if string.count < minLength {
            return false
        }
        
        if let maxLength = maxLength, string.count > maxLength {
            return false
        }
        
        return true
    }
    
    /// 验证字符串是否满足正则表达式
    static func matchesPattern(_ string: String, pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: string)
    }
    
    /// 验证是否为强密码（至少包含大小写字母、数字和特殊字符）
    static func isStrongPassword(_ password: String) -> Bool {
        // 至少8位，包含大小写字母、数字和特殊字符
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return matchesPattern(password, pattern: passwordRegex)
    }
    
    /// 验证是否为有效的身份证号码（中国）
    static func isValidChineseIDCard(_ idCard: String) -> Bool {
        // 简单验证格式：15位或18位，最后一位可能是X
        let idCardRegex = "^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}[\\dXx]$"
        return matchesPattern(idCard, pattern: idCardRegex)
    }
    
    /// 增强版中国身份证验证（包含校验码验证）
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
    static func isValidMacauIDCard(_ idCard: String) -> Bool {
        // 澳门身份证格式：开头可能有M/，后跟8位数字，最后一位是校验码
        let macauIDRegex = "^(M\\/)?[0-9]{8}[0-9A-Za-z]$"
        return matchesPattern(idCard, pattern: macauIDRegex)
    }
    
    /// 验证是否为有效的银行卡号
    static func isValidBankCardNumber(_ cardNumber: String) -> Bool {
        let digits = cardNumber.removingAllSpaces
        
        // 简单验证：13-19位数字
        if !digits.isNumeric || digits.count < 13 || digits.count > 19 {
            return false
        }
        
        // 使用Luhn算法验证
        return luhnCheck(digits)
    }
    
    /// Luhn算法实现
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
public class StringEncryptor {
    /// 对字符串进行URLEncoding编码
    static func urlEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    /// 对字符串进行URL解码
    static func urlDecode(_ string: String) -> String {
        return string.removingPercentEncoding ?? string
    }
    
    /// 使用指定密钥进行简单的异或加密
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


