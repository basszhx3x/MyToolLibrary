#if canImport(UIKit)
import UIKit

public struct DeviceInfo {
    /// 获取设备型号
    public static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// 获取系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取应用版本
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// 获取应用构建版本
    public static var buildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

public extension UIDevice {
    
    /// 顶部安全区域的高度 (20 / 44 / 47 / 59)
    static var topSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().top
    }
    
    /// 底部安全区域 (0 or 34)
    static var bottomSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().bottom
    }
}



//MARK: - 可以不关注。内部实现，为外部调用提供服务
extension UIDevice {
    
    fileprivate static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        
        // 既然是安全区域，非全面屏获取的虽然是0，但是毕竟有20高度的状态栏。也要空出来才可以不影响UI展示。
        let defalutArea: (CGFloat, CGFloat) = (20, 0)
        
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return defalutArea }
        guard let window = windowScene.windows.first else { return defalutArea }
        let inset = window.safeAreaInsets
        
        return (inset.top, inset.bottom)
    }
}

#endif
