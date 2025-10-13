import Foundation
import CommonCrypto
import Compression

// MARK: - Data 扩展
public extension Data {
    /// 将Data转换为十六进制字符串
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    /// 将Data转换为Base64编码字符串
    var base64EncodedString: String {
        return base64EncodedString()
    }
    
    /// 将Data转换为字符串（UTF-8编码）
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// 计算Data的MD5哈希值
    var md5: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_MD5($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 计算Data的SHA256哈希值
    var sha256: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 计算Data的SHA512哈希值
    var sha512: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_SHA512($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 使用Gzip压缩Data
    func gzipCompressed() -> Data? {
        var compressedData = Data()
        
        do {
            try withUnsafeBytes { (sourceBuffer: UnsafeRawBufferPointer) in
                guard let srcPtr = sourceBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                let algorithm = COMPRESSION_LZMA
                
                // 分配内存并初始化compression_stream
                let streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
                defer { streamPointer.deallocate() }
                
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 65536)
                defer { buffer.deallocate() }
                
                // 直接初始化compression_stream结构体
                streamPointer.pointee.dst_ptr = buffer
                streamPointer.pointee.dst_size = 65536
                streamPointer.pointee.src_ptr = srcPtr
                streamPointer.pointee.src_size = sourceBuffer.count
                streamPointer.pointee.state = nil
                
                let status = compression_stream_init(streamPointer, COMPRESSION_STREAM_ENCODE, algorithm)
                guard status == COMPRESSION_STATUS_OK else {
                    throw NSError(domain: "DataCompressionError", code: Int(status.rawValue), userInfo: nil)
                }
                
                defer {
                    compression_stream_destroy(streamPointer)
                }
                
                // 开始压缩循环
                while streamPointer.pointee.src_size > 0 {
                    let status = compression_stream_process(streamPointer, Int32(COMPRESSION_STREAM_FINALIZE.rawValue))
                    
                    if status == COMPRESSION_STATUS_OK || status == COMPRESSION_STATUS_END {
                        let count = 65536 - streamPointer.pointee.dst_size
                        if count > 0 {
                            compressedData.append(buffer, count: count)
                        }
                        
                        // 重置目标缓冲区
                        streamPointer.pointee.dst_ptr = buffer
                        streamPointer.pointee.dst_size = 65536
                    }
                    
                    if status == COMPRESSION_STATUS_END {
                        break
                    } else if status != COMPRESSION_STATUS_OK {
                        throw NSError(domain: "DataCompressionError", code: Int(status.rawValue), userInfo: nil)
                    }
                }
            }
        } catch {
            print("Gzip压缩失败: \(error)")
            return nil
        }
        
        return compressedData
    }
    
    /// 使用Gzip解压缩Data
    func gzipDecompressed() -> Data? {
        var decompressedData = Data()
        
        do {
            try withUnsafeBytes { (sourceBuffer: UnsafeRawBufferPointer) in
                guard let srcPtr = sourceBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                
                let algorithm = COMPRESSION_LZMA
                
                // 分配内存并初始化compression_stream
                let streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
                defer { streamPointer.deallocate() }
                
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 65536)
                defer { buffer.deallocate() }
                
                // 直接初始化compression_stream结构体
                streamPointer.pointee.dst_ptr = buffer
                streamPointer.pointee.dst_size = 65536
                streamPointer.pointee.src_ptr = srcPtr
                streamPointer.pointee.src_size = sourceBuffer.count
                streamPointer.pointee.state = nil
                
                var status = compression_stream_init(streamPointer, COMPRESSION_STREAM_DECODE, algorithm)
                guard status == COMPRESSION_STATUS_OK else {
                    throw NSError(domain: "DataDecompressionError", code: Int(status.rawValue), userInfo: nil)
                }
                
                defer {
                    compression_stream_destroy(streamPointer)
                }
                
                // 开始解压缩循环
                while streamPointer.pointee.src_size > 0 || status == COMPRESSION_STATUS_OK {
                    status = compression_stream_process(streamPointer, 0)
                    
                    if status == COMPRESSION_STATUS_OK || status == COMPRESSION_STATUS_END {
                        let count = 65536 - streamPointer.pointee.dst_size
                        if count > 0 {
                            decompressedData.append(buffer, count: count)
                        }
                        
                        // 重置目标缓冲区
                        streamPointer.pointee.dst_ptr = buffer
                        streamPointer.pointee.dst_size = 65536
                    }
                    
                    if status == COMPRESSION_STATUS_END {
                        break
                    } else if status != COMPRESSION_STATUS_OK {
                        throw NSError(domain: "DataDecompressionError", code: Int(status.rawValue), userInfo: nil)
                    }
                }
            }
        } catch {
            print("Gzip解压失败: \(error)")
            return nil
        }
        
        return decompressedData
    }
    
    /// 从Base64编码字符串创建Data
    static func fromBase64String(_ base64String: String) -> Data? {
        return Data(base64Encoded: base64String)
    }
    
    /// 从十六进制字符串创建Data
    static func fromHexString(_ hexString: String) -> Data? {
        var hex = hexString
        var data = Data()
        
        // 移除可能的空格
        hex = hex.replacingOccurrences(of: " ", with: "")
        
        // 确保字符串长度为偶数
        guard hex.count % 2 == 0 else {
            return nil
        }
        
        // 解析每两个字符为一个字节
        for i in stride(from: 0, to: hex.count, by: 2) {
            let startIndex = hex.index(hex.startIndex, offsetBy: i)
            let endIndex = hex.index(startIndex, offsetBy: 2)
            let byteString = String(hex[startIndex..<endIndex])
            
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            
            data.append(byte)
        }
        
        return data
    }
}

// MARK: - 数据加密工具类
public class CryptoHelper {
    /// AES加密（ECB模式，PKCS7填充）
    static func aesEncrypt(data: Data, key: Data) -> Data? {
        let cryptLength = size_t(kCCBlockSizeAES128 + data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            nil,
                            dataBytes.baseAddress,
                            data.count,
                            cryptBytes.baseAddress,
                            cryptLength,
                            &numBytesEncrypted)
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            return cryptData
        }
        
        return nil
    }
    
    /// AES解密（ECB模式，PKCS7填充）
    static func aesDecrypt(data: Data, key: Data) -> Data? {
        let cryptLength = data.count
        var cryptData = Data(count: cryptLength)
        
        let keyLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            nil,
                            dataBytes.baseAddress,
                            data.count,
                            cryptBytes.baseAddress,
                            cryptLength,
                            &numBytesDecrypted)
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            cryptData.removeSubrange(numBytesDecrypted..<cryptData.count)
            return cryptData
        }
        
        return nil
    }
    
    /// HMAC-SHA256签名
    static func hmacSHA256(data: Data, key: Data) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
                       keyBytes.baseAddress,
                       key.count,
                       dataBytes.baseAddress,
                       data.count,
                       &digest)
            }
        }
        
        return Data(digest)
    }
}

// MARK: - 数据转换工具类
public class DataConverter {
    /// 将任何Encodable类型转换为Data
    static func toData<T: Encodable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            return try encoder.encode(value)
        } catch {
            print("转换为Data失败: \(error)")
            return nil
        }
    }
    
    /// 将Data转换为任何Decodable类型
    static func fromData<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("从Data转换失败: \(error)")
            return nil
        }
    }
    
    /// 将JSON字符串转换为Data
    static func fromJSONString(_ jsonString: String) -> Data? {
        return jsonString.data(using: .utf8)
    }
    
    /// 将Data转换为JSON字符串
    static func toJSONString(_ data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - 数据验证工具类
public class DataValidator {
    /// 验证数据是否为空
    static func isEmpty(_ data: Data) -> Bool {
        return data.count == 0
    }
    
    /// 验证数据大小是否在指定范围内
    static func isSizeValid(_ data: Data, minSize: Int = 0, maxSize: Int? = nil) -> Bool {
        if data.count < minSize {
            return false
        }
        
        if let maxSize = maxSize, data.count > maxSize {
            return false
        }
        
        return true
    }
    
    /// 检查数据是否包含特定模式
    static func containsPattern(_ data: Data, pattern: Data) -> Bool {
        guard pattern.count > 0, pattern.count <= data.count else {
            return false
        }
        
        for i in 0...(data.count - pattern.count) {
            let range = i..<(i + pattern.count)
            let slice = data.subdata(in: range)
            if slice == pattern {
                return true
            }
        }
        
        return false
    }
}

// MARK: - 数据操作工具类
public class DataOperations {
    /// 合并多个Data对象
    static func merge(_ dataArray: [Data]) -> Data {
        var mergedData = Data()
        for data in dataArray {
            mergedData.append(data)
        }
        return mergedData
    }
    
    /// 分割Data为指定大小的块
    static func split(_ data: Data, chunkSize: Int) -> [Data] {
        guard chunkSize > 0, data.count > 0 else {
            return [data]
        }
        
        var chunks: [Data] = []
        let totalChunks = Int(ceil(Double(data.count) / Double(chunkSize)))
        
        for i in 0..<totalChunks {
            let startIndex = i * chunkSize
            let endIndex = min(startIndex + chunkSize, data.count)
            let chunk = data.subdata(in: startIndex..<endIndex)
            chunks.append(chunk)
        }
        
        return chunks
    }
    
    /// 从Data中提取指定范围的数据
    static func extractRange(_ data: Data, start: Int, length: Int) -> Data? {
        guard start >= 0, length >= 0, start + length <= data.count else {
            return nil
        }
        
        return data.subdata(in: start..<(start + length))
    }
}
