import Foundation

// MARK: - Array 扩展
public extension Array {
    /// 安全地获取数组元素，如果索引越界则返回nil
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// 将数组按指定大小分割成多个子数组
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    /// 获取数组的第一个元素，如果数组为空则返回nil
    var firstElement: Element? {
        return isEmpty ? nil : first
    }
    
    /// 获取数组的最后一个元素，如果数组为空则返回nil
    var lastElement: Element? {
        return isEmpty ? nil : last
    }
    
    /// 移除并返回数组的最后一个元素，如果数组为空则返回nil
    mutating func popLast() -> Element? {
        return isEmpty ? nil : removeLast()
    }
    
    /// 移除并返回数组的第一个元素，如果数组为空则返回nil
    mutating func popFirst() -> Element? {
        return isEmpty ? nil : removeFirst()
    }
    
    /// 将数组中的元素随机打乱顺序
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
    func shuffledElements() -> [Element] {
        var result = self
        result.shuffleElements()
        return result
    }
    
    /// 安全地插入元素到数组，如果索引越界则添加到末尾
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
public extension Array where Element: Equatable {
    /// 移除数组中的重复元素（仅当元素类型遵守Hashable协议时可用）
    func removingDuplicates() -> [Element] where Element: Hashable {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
    
    /// 移除数组中的重复元素（使用Equatable约束的版本）
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
    mutating func removeDuplicates() {
        self = removingDuplicatesEquatable()
    }
    
    /// 检查数组是否包含另一个数组的所有元素
    func containsAll(_ otherArray: [Element]) -> Bool {
        return otherArray.allSatisfy { self.contains($0) }
    }
    
    /// 检查数组是否包含另一个数组的任意一个元素
    func containsAny(_ otherArray: [Element]) -> Bool {
        return otherArray.contains { self.contains($0) }
    }
    
    /// 移除数组中第一次出现的指定元素
    @discardableResult
    mutating func removeFirstOccurrence(of element: Element) -> Bool {
        if let index = firstIndex(of: element) {
            remove(at: index)
            return true
        }
        return false
    }
    
    /// 移除数组中所有出现的指定元素
    @discardableResult
    mutating func removeAllOccurrences(of element: Element) -> Int {
        let countBefore = count
        removeAll { $0 == element }
        return countBefore - count
    }
    
    /// 返回两个数组的交集
    func intersection(with otherArray: [Element]) -> [Element] {
        return filter { otherArray.contains($0) }
    }
    
    /// 返回两个数组的并集
    func union(with otherArray: [Element]) -> [Element] {
        return self + otherArray.removingDuplicatesEquatable()
    }
    
    /// 返回在原数组中但不在另一个数组中的元素
    func difference(from otherArray: [Element]) -> [Element] {
        return filter { !otherArray.contains($0) }
    }
}

// MARK: - Dictionary 扩展
public extension Dictionary {
    /// 安全地获取字典中的值，如果键不存在则返回默认值
    func value(forKey key: Key, default defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
    
    /// 合并两个字典，有冲突时使用第二个字典的值
    mutating func merge(with dictionary: Dictionary<Key, Value>) {
        dictionary.forEach { self[$0.key] = $0.value }
    }
    
    /// 返回一个合并后的新字典，有冲突时使用第二个字典的值
    func merged(with dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var result = self
        result.merge(with: dictionary)
        return result
    }
    
    /// 检查字典是否包含指定的键
    func contains(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// 将字典转换为URL查询字符串
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
    var keysArray: [Key] {
        return Array(keys)
    }
    
    /// 获取字典的值数组
    var valuesArray: [Value] {
        return Array(values)
    }
    
    /// 创建一个从值到键的反转字典（假设值是唯一的）
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
    mutating func remove(key: Key) -> Value? {
        return removeValue(forKey: key)
    }
}

// MARK: - 键为字符串的 Dictionary 扩展
public extension Dictionary where Key == String {
    /// 获取字典中的字符串值，如果键不存在或值不是字符串则返回nil
    func stringValue(for key: Key) -> String? {
        return self[key] as? String
    }
    
    /// 获取字典中的整数值，如果键不存在或值不能转换为整数则返回nil
    func intValue(for key: Key) -> Int? {
        if let intValue = self[key] as? Int {
            return intValue
        } else if let stringValue = self[key] as? String {
            return Int(stringValue)
        }
        return nil
    }
    
    /// 获取字典中的布尔值，如果键不存在或值不能转换为布尔值则返回nil
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
    func dictionaryValue(for key: Key) -> [String: Any]? {
        return self[key] as? [String: Any]
    }
    
    /// 获取字典中的数组，如果键不存在或值不是数组则返回nil
    func arrayValue(for key: Key) -> [Any]? {
        return self[key] as? [Any]
    }
}