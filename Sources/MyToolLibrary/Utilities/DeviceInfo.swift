#if canImport(UIKit)
import UIKit

/// 设备信息结构体
/// 
/// 提供获取设备相关信息的静态方法
public struct DeviceInfo {
    /// 获取设备型号
    /// 
    /// 获取设备的具体型号标识符（如iPhone14,1、iPad13,1等）
    /// - Returns: 设备型号标识符字符串
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
    /// 
    /// 获取iOS系统的版本号（如15.4、16.0等）
    /// - Returns: 系统版本字符串
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取应用版本
    /// 
    /// 获取应用的显示版本号（CFBundleShortVersionString）
    /// - Returns: 应用版本字符串，如果获取失败则返回"Unknown"
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// 获取应用构建版本
    /// 
    /// 获取应用的构建版本号（CFBundleVersion）
    /// - Returns: 应用构建版本字符串，如果获取失败则返回"Unknown"
    public static var buildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    /// 判断是否为iPad设备
    /// 
    /// 通过设备的用户界面风格判断是否为iPad设备
    /// - Returns: 如果是iPad设备返回true，否则返回false
    public static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 判断是否为iPhone X及以后的全面屏设备
    /// 
    /// 通过检查设备的安全区域底部高度来判断是否为全面屏设备
    /// - Returns: 如果是全面屏设备返回true，否则返回false
    public static var isIPhoneX: Bool {
        // iPhone X及以后的全面屏设备底部安全区域高度大于0
        let window = UIApplication.shared.windows.first
        return UIDevice.current.userInterfaceIdiom == .phone && (window?.safeAreaInsets.bottom ?? 0) > 0
    }
    
    /// 判断是否处于分屏模式
    /// 
    /// 通过检查当前窗口的尺寸是否小于屏幕的完整尺寸来判断是否处于分屏模式
    /// - Returns: 如果处于分屏模式返回true，否则返回false
    public static var isSplitScreen: Bool {
        guard let window = UIApplication.shared.windows.first else { return false }
        let screenSize = UIScreen.main.bounds.size
        let windowSize = window.bounds.size
        
        // 检查窗口是否小于屏幕的完整尺寸
        return windowSize.width < screenSize.width || windowSize.height < screenSize.height
    }
}

/// UIDevice扩展
/// 
/// 提供获取安全区域信息的便捷方法
public extension UIDevice {
    
    /// 顶部安全区域的高度
    /// 
    /// 返回设备顶部的安全区域高度，对于不同设备类型可能是20、44、47或59pt
    /// - Returns: 顶部安全区域高度（pt）
    static var topSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().top
    }
    
    /// 底部安全区域高度
    /// 
    /// 返回设备底部的安全区域高度，对于非全面屏设备返回0，对于全面屏设备通常返回34pt
    /// - Returns: 底部安全区域高度（pt）
    static var bottomSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().bottom
    }
}



//MARK: - 可以不关注。内部实现，为外部调用提供服务
//MARK: - 可以不关注。内部实现，为外部调用提供服务
/// UIDevice内部扩展
/// 
/// 提供获取安全区域信息的内部实现方法
fileprivate extension UIDevice {
    
    /// 获取安全区域内边距
    /// 
    /// 内部方法，用于获取当前设备的顶部和底部安全区域高度
    /// - Returns: 包含顶部和底部安全区域高度的元组
    static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        
        // 既然是安全区域，非全面屏获取的虽然是0，但是毕竟有20高度的状态栏。也要空出来才可以不影响UI展示。
        // 为非全面屏设备设置默认值(20, 0)，确保UI布局合理
        let defalutArea: (CGFloat, CGFloat) = (20, 0)
        
        // 通过UIApplication获取当前连接的场景
        let scene = UIApplication.shared.connectedScenes.first
        // 确保场景是UIWindowScene类型
        guard let windowScene = scene as? UIWindowScene else { return defalutArea }
        // 获取窗口场景中的第一个窗口
        guard let window = windowScene.windows.first else { return defalutArea }
        // 获取窗口的安全区域内边距
        let inset = window.safeAreaInsets
        
        return (inset.top, inset.bottom)
    }
}

#endif
