//
//  UIScene+Extension.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/20.
//

import Foundation

public extension UIScene {
    
    @MainActor
    static func currentScene() -> UIScene? {
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
        
        guard let windowScene = windowScene else { return nil }
        return windowScene
    }
    
    @discardableResult
    static func keySceneDelegate() -> UISceneDelegate? {
        
        guard let scene = UIScene.currentScene() else { return nil }
        guard let delegate = scene.delegate else { return nil }
        return delegate
        
    }
}
