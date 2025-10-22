import Foundation
import CommonCrypto
import Compression

/// 图片格式枚举
/// 
/// 用于标识各种常见的图片文件格式
public enum ImageFormat {
    /// JPEG格式
    case jpeg
    /// PNG格式
    case png
    /// GIF格式
    case gif
    /// WebP格式
    case webp
    /// TIFF格式
    case tiff
    /// 未知格式
    case unknown
}
// MARK: - Data 扩展
/// 为Data类型提供各种便捷操作和转换方法
public extension Data {
    /// 将Data转换为十六进制字符串
    /// 
    /// 每个字节转换为两个十六进制字符，如0xAB转换为"ab"
    /// - Returns: 小写的十六进制表示的字符串
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    /// 将Data转换为Base64编码字符串
    /// 
    /// 使用标准的Base64编码，不包含换行符
    /// - Returns: Base64编码后的字符串
    var base64EncodedString: String {
        return base64EncodedString()
    }
    
    /// 将Data转换为字符串（UTF-8编码）
    /// 
    /// 尝试使用UTF-8编码将数据转换为字符串
    /// - Returns: 转换后的字符串，如果数据不是有效的UTF-8编码则返回nil
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// 计算Data的MD5哈希值
    /// 
    /// 使用CommonCrypto框架计算MD5哈希值
    /// - Returns: 16字节的MD5哈希值
    var md5: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_MD5($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 计算Data的SHA256哈希值
    /// 
    /// 使用CommonCrypto框架计算SHA256哈希值
    /// - Returns: 32字节的SHA256哈希值
    var sha256: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 计算Data的SHA512哈希值
    /// 
    /// 使用CommonCrypto框架计算SHA512哈希值
    /// - Returns: 64字节的SHA512哈希值
    var sha512: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        withUnsafeBytes { _ = CC_SHA512($0.baseAddress, CC_LONG(count), &hash) }
        return Data(hash)
    }
    
    /// 使用Gzip/LZMA算法压缩Data
    /// 
    /// 使用系统的Compression框架进行数据压缩
    /// - Returns: 压缩后的数据，如果压缩失败则返回nil
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
    
    /// 使用Gzip/LZMA算法解压缩Data
    /// 
    /// 使用系统的Compression框架进行数据解压缩
    /// - Returns: 解压缩后的数据，如果解压缩失败则返回nil
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
    /// 
    /// - Parameter base64String: Base64编码的字符串
    /// - Returns: 解码后的Data对象，如果字符串不是有效的Base64格式则返回nil
    static func fromBase64String(_ base64String: String) -> Data? {
        return Data(base64Encoded: base64String)
    }
    
    /// 从十六进制字符串创建Data
    /// 
    /// 解析十六进制字符串为字节数据
    /// - Parameter hexString: 十六进制格式的字符串，可以包含空格
    /// - Returns: 解析后的Data对象，如果字符串格式不正确则返回nil
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
/// 提供各种加密和解密功能的工具类
public class CryptoHelper {
    /// AES加密（ECB模式，PKCS7填充）
    /// 
    /// 使用AES-256算法进行加密
    /// - Parameters:
    ///   - data: 要加密的数据
    ///   - key: 加密密钥，建议使用32字节长度
    /// - Returns: 加密后的数据，如果加密失败则返回nil
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
    /// 
    /// 使用AES-256算法进行解密
    /// - Parameters:
    ///   - data: 要解密的数据
    ///   - key: 解密密钥，必须与加密密钥相同
    /// - Returns: 解密后的数据，如果解密失败则返回nil
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
    /// 
    /// 使用指定密钥对数据进行HMAC-SHA256签名
    /// - Parameters:
    ///   - data: 要签名的数据
    ///   - key: 签名密钥
    /// - Returns: 32字节的HMAC-SHA256签名数据
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
/// 提供数据转换功能的工具类，主要用于JSON和对象之间的转换
public class DataConverter {
    /// 将任何Encodable类型转换为Data
    /// 
    /// 将Swift对象编码为JSON数据
    /// - Parameter value: 要转换的Encodable对象
    /// - Returns: 编码后的JSON数据，如果编码失败则返回nil
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
    /// 
    /// 将JSON数据解码为Swift对象
    /// - Parameters:
    ///   - data: 要解码的JSON数据
    ///   - type: 目标类型
    /// - Returns: 解码后的对象，如果解码失败则返回nil
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
    /// 
    /// - Parameter jsonString: JSON格式的字符串
    /// - Returns: 对应的Data对象，如果字符串不是有效的UTF-8编码则返回nil
    static func fromJSONString(_ jsonString: String) -> Data? {
        return jsonString.data(using: .utf8)
    }
    
    /// 将Data转换为JSON字符串
    /// 
    /// - Parameter data: 要转换的数据，通常是JSON数据
    /// - Returns: 转换后的字符串，如果数据不是有效的UTF-8编码则返回nil
    static func toJSONString(_ data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - 数据验证工具类
/// 提供数据验证功能的工具类
public class DataValidator {
    /// 验证数据是否为空
    /// 
    /// - Parameter data: 要验证的数据
    /// - Returns: 如果数据长度为0则返回true，否则返回false
    static func isEmpty(_ data: Data) -> Bool {
        return data.count == 0
    }
    
    /// 验证数据大小是否在指定范围内
    /// 
    /// - Parameters:
    ///   - data: 要验证的数据
    ///   - minSize: 最小允许的字节数，默认为0
    ///   - maxSize: 最大允许的字节数，为nil时表示不限制
    /// - Returns: 如果数据大小在范围内则返回true，否则返回false
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
    /// 
    /// 使用线性搜索算法检查数据中是否包含指定的字节模式
    /// - Parameters:
    ///   - data: 要搜索的原始数据
    ///   - pattern: 要查找的字节模式
    /// - Returns: 如果找到匹配的模式则返回true，否则返回false
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
/// 提供数据操作功能的工具类
public class DataOperations {
    /// 合并多个Data对象
    /// 
    /// 按顺序将多个Data对象合并为一个
    /// - Parameter dataArray: 要合并的Data对象数组
    /// - Returns: 合并后的Data对象
    static func merge(_ dataArray: [Data]) -> Data {
        var mergedData = Data()
        for data in dataArray {
            mergedData.append(data)
        }
        return mergedData
    }
    
    /// 分割Data为指定大小的块
    /// 
    /// 将数据分割成多个指定大小的块
    /// - Parameters:
    ///   - data: 要分割的数据
    ///   - chunkSize: 每个块的大小（字节）
    /// - Returns: 分割后的Data块数组
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
    /// 
    /// - Parameters:
    ///   - data: 原始数据
    ///   - start: 起始位置（字节偏移量）
    ///   - length: 要提取的数据长度（字节）
    /// - Returns: 提取的子数据，如果范围无效则返回nil
    static func extractRange(_ data: Data, start: Int, length: Int) -> Data? {
        guard start >= 0, length >= 0, start + length <= data.count else {
            return nil
        }
        
        return data.subdata(in: start..<(start + length))
    }
}

public extension Data {
    /// 判断图片数据的格式
    /// 
    /// 通过检查文件头字节来识别常见的图片格式
    /// - Returns: 识别出的图片格式，如果无法识别则返回.unknown
    var imageFormat: ImageFormat {
        // 检查数据长度是否足够读取文件头
        guard count >= 4 else { return .unknown }
        
        // 读取前几个字节（根据需要调整读取长度）
        let header = self[0..<8] // 取前8字节，覆盖大部分格式的判断需求
        let bytes = [UInt8](header)
        
        // JPEG: 0xFF 0xD8 0xFF
        if bytes.count >= 3,
           bytes[0] == 0xFF,
           bytes[1] == 0xD8,
           bytes[2] == 0xFF {
            return .jpeg
        }
        
        // PNG: 0x89 0x50 0x4E 0x47 0x0D 0x0A 0x1A 0x0A
        if bytes.count >= 8,
           bytes[0] == 0x89,
           bytes[1] == 0x50,
           bytes[2] == 0x4E,
           bytes[3] == 0x47,
           bytes[4] == 0x0D,
           bytes[5] == 0x0A,
           bytes[6] == 0x1A,
           bytes[7] == 0x0A {
            return .png
        }
        
        // GIF: 0x47 0x49 0x46 0x38（"GIF8"）
        if bytes.count >= 4,
           bytes[0] == 0x47,
           bytes[1] == 0x49,
           bytes[2] == 0x46,
           bytes[3] == 0x38 {
            return .gif
        }
        
        // WebP: 前4字节 0x52 0x49 0x46 0x46（"RIFF"），后4字节 0x57 0x45 0x42 0x50（"WEBP"）
        if bytes.count >= 8,
           bytes[0] == 0x52,
           bytes[1] == 0x49,
           bytes[2] == 0x46,
           bytes[3] == 0x46,
           bytes[4] == 0x57,
           bytes[5] == 0x45,
           bytes[6] == 0x42,
           bytes[7] == 0x50 {
            return .webp
        }
        
        // TIFF: 两种格式 0x49 0x49 0x2A 0x00 或 0x4D 0x4D 0x00 0x2A
        if bytes.count >= 4 {
            let tiff1 = bytes[0] == 0x49 && bytes[1] == 0x49 && bytes[2] == 0x2A && bytes[3] == 0x00
            let tiff2 = bytes[0] == 0x4D && bytes[1] == 0x4D && bytes[2] == 0x00 && bytes[3] == 0x2A
            if tiff1 || tiff2 {
                return .tiff
            }
        }
        
        return .unknown
    }
}
