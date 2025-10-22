import Foundation

/// 网络请求管理类
/// 
/// 提供简洁的网络请求接口，支持GET请求并自动进行JSON解析
public class NetworkManager {
    /// NetworkManager的共享实例
    /// 
    /// 使用单例模式确保全局只有一个NetworkManager实例
    public static let shared = NetworkManager()
    
    /// 私有初始化方法
    /// 
    /// 防止外部直接创建NetworkManager实例
    private init() {}
    
    /// 执行GET请求并将结果解码为指定的Decodable类型
    /// 
    /// 使用URLSession发送GET请求，自动处理响应数据的JSON解码
    /// - Parameters:
    ///   - url: 请求的URL字符串
    ///   - completion: 请求完成后的回调闭包，包含Result<T, Error>类型的结果
    /// - Returns: 无返回值，结果通过completion回调返回
    public func get<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        // 验证URL格式是否正确
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        // 使用URLSession.shared创建并执行数据任务
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 检查是否有网络请求错误
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 检查是否接收到了响应数据
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            
            // 尝试将JSON数据解码为指定的类型
            do {
                // 使用JSONDecoder解码数据为泛型T类型
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                // 解码成功，通过completion返回成功结果
                completion(.success(decodedObject))
            } catch {
                // 解码失败，捕获错误
                completion(.failure(error))
            }
        }.resume() // 开始执行网络请求
    }
}