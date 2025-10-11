//
//  DataObservable.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/11.
//

import Foundation

@MainActor
open class ChimpObservable<T> {
    public typealias ChimpObservable = (T) -> Void
    public var observer: ChimpObservable?
    public var observers: [ChimpObservable?] = []
    
    public func observe(_ observer: ChimpObservable?) {
        self.observer = observer
        observer?(value)
    }
    
    //单利需要多个对象发布
    public func observeMore(_ observer: ChimpObservable?) {
        observers.append(observer)
        observer?(value)
    }
    
    public var value: T {
        didSet {
            if observers.count > 0 {
                observers.forEach { observer in
                    observer?(value)
                }
            }
            else {
                observer?(value)
            }
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
}
