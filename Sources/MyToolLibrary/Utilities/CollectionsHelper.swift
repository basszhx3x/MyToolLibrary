import Foundation

// MARK: - Array 扩展
/// 为数组提供各种安全操作和便捷方法的扩展
public extension Array {
    /// 安全地获取数组元素，如果索引越界则返回nil
    /// 
    /// 避免数组索引越界导致的崩溃
    /// - Parameter index: 要获取元素的索引
    /// - Returns: 索引对应的元素，如果索引越界则返回nil
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// 将数组按指定大小分割成多个子数组
    /// 
    /// - Parameter size: 每个子数组的最大大小
    /// - Returns: 分割后的子数组集合
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    /// 获取数组的第一个元素，如果数组为空则返回nil
    /// 
    /// 与直接使用first属性功能相同，但提供了更明确的命名
    var firstElement: Element? {
        return isEmpty ? nil : first
    }
    
    /// 获取数组的最后一个元素，如果数组为空则返回nil
    /// 
    /// 与直接使用last属性功能相同，但提供了更明确的命名
    var lastElement: Element? {
        return isEmpty ? nil : last
    }
    
    /// 移除并返回数组的最后一个元素，如果数组为空则返回nil
    /// 
    /// 安全版本的removeLast()，不会在数组为空时崩溃
    /// - Returns: 被移除的最后一个元素，如果数组为空则返回nil
    mutating func popLast() -> Element? {
        return isEmpty ? nil : removeLast()
    }
    
    /// 移除并返回数组的第一个元素，如果数组为空则返回nil
    /// 
    /// 安全版本的removeFirst()，不会在数组为空时崩溃
    /// - Returns: 被移除的第一个元素，如果数组为空则返回nil
    mutating func popFirst() -> Element? {
        return isEmpty ? nil : removeFirst()
    }
    
    /// 将数组中的元素随机打乱顺序
    /// 
    /// 使用Fisher-Yates洗牌算法原地打乱数组元素
    mutating func shuffleElements() {
        if count > 1 {
            for i in stride(from: count - 1, to: 0, by: -1) {
                let j = Int(arc4random_uniform(UInt32(i + 1)))
                if i != j {
                    swapAt(i, j)
                }
            }
        }
    }
    
    /// 返回一个新数组，包含原数组中所有元素的随机排列
    /// 
    /// 与shuffleElements()不同，此方法不会修改原数组，而是返回一个新的打乱数组
    /// - Returns: 元素随机排列的新数组
    func shuffledElements() -> [Element] {
        var result = self
        result.shuffleElements()
        return result
    }
    
    /// 安全地插入元素到数组，如果索引越界则添加到开头或末尾
    /// 
    /// - 如果索引小于0：插入到数组开头
    /// - 如果索引大于等于数组长度：追加到数组末尾
    /// - 否则：在指定索引处插入
    /// - Parameters:
    ///   - element: 要插入的元素
    ///   - index: 要插入的位置索引
    mutating func safeInsert(_ element: Element, at index: Index) {
        if index < 0 {
            insert(element, at: 0)
        } else if index >= count {
            append(element)
        } else {
            insert(element, at: index)
        }
    }
}

// MARK: - 元素可比较的 Array 扩展
/// 为可比较元素类型的数组提供额外的集合操作方法
public extension Array where Element: Equatable {
    /// 移除数组中的重复元素（高效版本，仅当元素类型遵守Hashable协议时可用）
    /// 
    /// 使用Set进行去重，时间复杂度为O(n)
    /// - Returns: 去重后的新数组，保留元素首次出现的顺序
    func removingDuplicates() -> [Element] where Element: Hashable {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
    
    /// 移除数组中的重复元素（使用Equatable约束的版本）
    /// 
    /// 适用于所有遵守Equatable协议的元素类型，时间复杂度为O(n²)
    /// - Returns: 去重后的新数组，保留元素首次出现的顺序
    func removingDuplicatesEquatable() -> [Element] {
        var result: [Element] = []
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
    
    /// 原地移除数组中的重复元素
    /// 
    /// 修改原数组，移除所有重复元素
    mutating func removeDuplicates() {
        self = removingDuplicatesEquatable()
    }
    
    /// 检查数组是否包含另一个数组的所有元素
    /// 
    /// - Parameter otherArray: 要检查的子数组
    /// - Returns: 如果原数组包含otherArray中的所有元素则返回true，否则返回false
    func containsAll(_ otherArray: [Element]) -> Bool {
        return otherArray.allSatisfy { self.contains($0) }
    }
    
    /// 检查数组是否包含另一个数组的任意一个元素
    /// 
    /// - Parameter otherArray: 要检查的数组
    /// - Returns: 如果原数组包含otherArray中的至少一个元素则返回true，否则返回false
    func containsAny(_ otherArray: [Element]) -> Bool {
        return otherArray.contains { self.contains($0) }
    }
    
    /// 移除数组中第一次出现的指定元素
    /// 
    /// - Parameter element: 要移除的元素
    /// - Returns: 如果成功移除元素则返回true，如果数组中不包含该元素则返回false
    @discardableResult
    mutating func removeFirstOccurrence(of element: Element) -> Bool {
        if let index = firstIndex(of: element) {
            remove(at: index)
            return true
        }
        return false
    }
    
    /// 移除数组中所有出现的指定元素
    /// 
    /// - Parameter element: 要移除的元素
    /// - Returns: 移除的元素个数
    @discardableResult
    mutating func removeAllOccurrences(of element: Element) -> Int {
        let countBefore = count
        removeAll { $0 == element }
        return countBefore - count
    }
    
    /// 返回两个数组的交集
    /// 
    /// - Parameter otherArray: 要计算交集的另一个数组
    /// - Returns: 同时存在于两个数组中的元素组成的新数组
    func intersection(with otherArray: [Element]) -> [Element] {
        return filter { otherArray.contains($0) }
    }
    
    /// 返回两个数组的并集
    /// 
    /// - Parameter otherArray: 要计算并集的另一个数组
    /// - Returns: 包含两个数组所有唯一元素的新数组
    func union(with otherArray: [Element]) -> [Element] {
        return self + otherArray.removingDuplicatesEquatable()
    }
    
    /// 返回在原数组中但不在另一个数组中的元素（差集）
    /// 
    /// - Parameter otherArray: 要比较的另一个数组
    /// - Returns: 只存在于原数组中而不存在于otherArray中的元素组成的新数组
    func difference(from otherArray: [Element]) -> [Element] {
        return filter { !otherArray.contains($0) }
    }
}

// MARK: - Dictionary 扩展
/// 为字典提供各种安全操作和便捷方法的扩展
public extension Dictionary {
    /// 安全地获取字典中的值，如果键不存在则返回默认值
    /// 
    /// - Parameters:
    ///   - key: 要查询的键
    ///   - defaultValue: 当键不存在时返回的默认值
    /// - Returns: 键对应的值，如果键不存在则返回默认值
    func value(forKey key: Key, default defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
    
    /// 合并两个字典，有冲突时使用第二个字典的值
    /// 
    /// 修改原字典，将另一个字典的键值对添加到原字典中
    /// - Parameter dictionary: 要合并的字典
    mutating func merge(with dictionary: Dictionary<Key, Value>) {
        dictionary.forEach { self[$0.key] = $0.value }
    }
    
    /// 返回一个合并后的新字典，有冲突时使用第二个字典的值
    /// 
    /// 创建并返回一个新字典，包含两个字典的所有键值对
    /// - Parameter dictionary: 要合并的字典
    /// - Returns: 合并后的新字典
    func merged(with dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var result = self
        result.merge(with: dictionary)
        return result
    }
    
    /// 检查字典是否包含指定的键
    /// 
    /// - Parameter key: 要检查的键
    /// - Returns: 如果字典包含该键则返回true，否则返回false
    func contains(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// 将字典转换为URL查询字符串
    /// 
    /// 仅支持键为String类型，值为CustomStringConvertible的字典
    /// - Returns: 格式化的URL查询字符串，如"key1=value1&key2=value2"
    func toQueryString() -> String? {
        guard !isEmpty else { return nil }
        
        let queryItems = self.compactMap { key, value -> URLQueryItem? in
            guard let stringKey = key as? String, let stringValue = value as? CustomStringConvertible else {
                return nil
            }
            return URLQueryItem(name: stringKey, value: String(describing: stringValue))
        }
        
        var components = URLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery
    }
    
    /// 获取字典的键数组
    /// 
    /// 将字典的所有键转换为数组
    var keysArray: [Key] {
        return Array(keys)
    }
    
    /// 获取字典的值数组
    /// 
    /// 将字典的所有值转换为数组
    var valuesArray: [Value] {
        return Array(values)
    }
    
    /// 创建一个从值到键的反转字典（假设值是唯一的）
    /// 
    /// - Returns: 如果所有值都是唯一的，则返回反转后的字典；如果有重复值，则返回nil
    func flipped() -> [Value: Key]? where Value: Hashable {
        var flippedDict = [Value: Key]()
        for (key, value) in self {
            if flippedDict[value] != nil {
                return nil // 值不唯一，无法反转
            }
            flippedDict[value] = key
        }
        return flippedDict
    }
    
    /// 安全地移除字典中的键值对，并返回被移除的值
    /// 
    /// 与removeValue(forKey:)功能相同，但提供了更直观的命名
    /// - Parameter key: 要移除的键
    /// - Returns: 被移除的值，如果键不存在则返回nil
    mutating func remove(key: Key) -> Value? {
        return removeValue(forKey: key)
    }
}

// MARK: - 键为字符串的 Dictionary 扩展
/// 为键为String类型的字典提供类型安全的值获取方法
public extension Dictionary where Key == String {
    /// 获取字典中的字符串值，如果键不存在或值不是字符串则返回nil
    /// 
    /// - Parameter key: 要查询的键
    /// - Returns: 字符串值，如果键不存在或类型不匹配则返回nil
    func stringValue(for key: Key) -> String? {
        return self[key] as? String
    }
    
    /// 获取字典中的整数值，如果键不存在或值不能转换为整数则返回nil
    /// 
    /// 支持直接转换为Int，或从String转换为Int
    /// - Parameter key: 要查询的键
    /// - Returns: 整数值，如果键不存在或无法转换则返回nil
    func intValue(for key: Key) -> Int? {
        if let intValue = self[key] as? Int {
            return intValue
        } else if let stringValue = self[key] as? String {
            return Int(stringValue)
        }
        return nil
    }
    
    /// 获取字典中的布尔值，如果键不存在或值不能转换为布尔值则返回nil
    /// 
    /// 支持直接转换为Bool，或从Int、String转换为Bool
    /// - Parameter key: 要查询的键
    /// - Returns: 布尔值，如果键不存在或无法转换则返回nil
    func boolValue(for key: Key) -> Bool? {
        if let boolValue = self[key] as? Bool {
            return boolValue
        } else if let intValue = self[key] as? Int {
            return intValue != 0
        } else if let stringValue = self[key] as? String {
            return stringValue.lowercased() == "true" || stringValue == "1"
        }
        return nil
    }
    
    /// 获取字典中的浮点数，如果键不存在或值不能转换为浮点数则返回nil
    /// 
    /// 支持直接转换为Double，或从Int、String转换为Double
    /// - Parameter key: 要查询的键
    /// - Returns: 浮点数值，如果键不存在或无法转换则返回nil
    func doubleValue(for key: Key) -> Double? {
        if let doubleValue = self[key] as? Double {
            return doubleValue
        } else if let intValue = self[key] as? Int {
            return Double(intValue)
        } else if let stringValue = self[key] as? String {
            return Double(stringValue)
        }
        return nil
    }
    
    /// 获取字典中的子字典，如果键不存在或值不是字典则返回nil
    /// 
    /// - Parameter key: 要查询的键
    /// - Returns: 子字典，如果键不存在或类型不匹配则返回nil
    func dictionaryValue(for key: Key) -> [String: Any]? {
        return self[key] as? [String: Any]
    }
    
    /// 获取字典中的数组，如果键不存在或值不是数组则返回nil
    /// 
    /// - Parameter key: 要查询的键
    /// - Returns: 数组，如果键不存在或类型不匹配则返回nil
    func arrayValue(for key: Key) -> [Any]? {
        return self[key] as? [Any]
    }
}