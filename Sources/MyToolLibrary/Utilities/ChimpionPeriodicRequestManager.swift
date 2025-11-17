//
//  AdvancedPeriodicRequestManager.swift
//  igather
//
//  Created by basszhx3x on 2025/11/4.
//

import Foundation

struct OperationHandler {
    // 第一个闭包：无参无返回值（例如：触发某个操作）
    let action: (@escaping (Result<Any, Error>) -> Void) -> Void
    // 第二个闭包：接收 Result<Data, Error>（例如：处理操作结果）
    let completion: (Result<Any, Error>) -> Void
}

class AdvancedPeriodicRequestManager {
    enum RequestState {
        case stopped
        case running
        case paused
    }
    
    // MARK: - 配置
    struct Configuration {
        let timeInterval: TimeInterval
        let autoStart: Bool
        let continueOnError: Bool
        let maxRetries: Int
        
        static let `default` = Configuration(
            timeInterval: 5.0,
            autoStart: false,
            continueOnError: true,
            maxRetries: 3
        )
    }
    
    // MARK: - 属性
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "com.youapp.advancedPeriodicRequest")
    private var state: RequestState = .stopped
    private var retryCount = 0
    
    let configuration: Configuration
    var onStateChanged: ((RequestState) -> Void)?
    
    var handle : OperationHandler?
    
    // MARK: - 初始化
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        
        if configuration.autoStart {
            start()
        }
        
    }
    
    // MARK: - 公共方法
    func start() {
        guard state != .running else { return }
        
        setState(.running)
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: configuration.timeInterval)
        timer?.setEventHandler { [weak self] in
            self?.executeRequest()
        }
        timer?.resume()
    }
    
    func stop() {
        guard state != .stopped else { return }
        
        timer?.cancel()
        timer = nil
        setState(.stopped)
        retryCount = 0
    }
    
    func pause() {
        guard state == .running else { return }
        timer?.suspend()
        setState(.paused)
    }
    
    func resume() {
        guard state == .paused else { return }
        timer?.resume()
        setState(.running)
    }
    
    // MARK: - 私有方法
    private func setState(_ newState: RequestState) {
        state = newState
        DispatchQueue.main.async {
            self.onStateChanged?(newState)
        }
    }
    
    private func executeRequest() {
        
        handle?.action{ res in
            switch res {
            case .success(let data):
                self.handleRequestSuccess(data)
            case .failure(let error):
                self.handleRequestFailure(error)
            }
        }
    }
    
    private func handleRequestSuccess(_ data: Any) {
        retryCount = 0 // 重置重试计数
        
        DispatchQueue.main.async {[self] in
            handle?.completion(.success(data))
        }
    }
    
    private func handleRequestFailure(_ error: Error) {
        retryCount += 1
        
        if retryCount >= configuration.maxRetries {
            print("达到最大重试次数，停止请求")
            DispatchQueue.main.async {
                self.stop()
            }
        } else if !configuration.continueOnError {
            print("配置为错误时停止，暂停请求")
            DispatchQueue.main.async {
                self.pause()
            }
        }
        
        DispatchQueue.main.async {[self] in
            handle?.completion(.failure(error))
        }
    }
    
    deinit {
        handle = nil
        timer?.cancel()
        timer = nil
    }
}
