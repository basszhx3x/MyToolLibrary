//
//  DataObservable.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation

/// 泛型数据观察器类
/// 
/// 实现了观察者模式，用于在数据变化时通知订阅者
/// 使用@MainActor确保所有观察回调在主线程执行
@MainActor
open class ChimpObservable<T> {
    /// 观察者闭包类型定义
    public typealias ChimpObserver = (T) -> Void
    /// 单个观察者引用
    public var observer: ChimpObserver?
    /// 多个观察者引用数组
    public var observers: [ChimpObserver?] = []
    
    /// 设置单个观察者
    /// 
    /// 替换现有的观察者，并立即使用当前值触发回调
    /// - Parameter observer: 观察闭包，接收泛型值作为参数
    public func observe(_ observer: ChimpObserver?) {
        self.observer = observer
        // 立即使用当前值触发观察者回调
        observer?(value)
    }
    
    /// 添加多个观察者
    /// 
    /// 用于支持多个对象订阅同一数据变化
    /// - Parameter observer: 观察闭包，接收泛型值作为参数
    public func observeMore(_ observer: ChimpObserver?) {
        self.observers.append(observer)
        // 立即使用当前值触发新添加的观察者回调
        observer?(self.value)
    }
    
    /// 被观察的值
    /// 
    /// 当值发生变化时，会通知所有已注册的观察者
    public var value: T {
        didSet {
            // 当有多个观察者时，遍历通知所有观察者
            if self.observers.count > 0 {
                self.observers.forEach { observer in
                    observer?(self.value)
                }
            }
            else {
                // 只有单个观察者时，直接通知
                self.observer?(self.value)
            }
        }
    }
    
    /// 初始化观察器
    /// 
    /// - Parameter value: 初始值
    public init(_ value: T) {
        self.value = value
    }
}
