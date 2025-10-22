#if canImport(UIKit)
import UIKit

public extension UIView {
    /// 为视图添加圆角效果
    /// - Parameter radius: 圆角半径值
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 为视图添加边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    /// 为视图添加阴影效果
    /// - Parameters:
    ///   - color: 阴影颜色，默认为黑色
    ///   - opacity: 阴影透明度，范围0.0-1.0，默认为0.5
    ///   - offset: 阴影偏移量，默认为(0, 2)
    ///   - radius: 阴影模糊半径，默认为4
    func addShadow(color: UIColor = .black, 
                   opacity: Float = 0.5, 
                   offset: CGSize = CGSize(width: 0, height: 2), 
                   radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false // 确保阴影可见，不被裁剪
    }
}

public extension UIView {
    /// 创建并配置新视图的便捷方法
    ///
    /// 此方法创建一个新的视图实例，并自动设置`translatesAutoresizingMaskIntoConstraints = false`
    /// 然后通过可选的闭包进行进一步配置。
    ///
    /// - Parameter builder: 配置视图的闭包函数，接收新创建的视图实例
    /// - Returns: 配置完成的视图实例
    ///
    /// 用法示例：
    /// ```
    ///    private let button: UIButton = .build { button in
    ///        button.setTitle("Tap me!", for: .normal)
    ///        button.backgroundColor = .systemPink
    ///    }
    /// ```
    static func build<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        // 创建视图实例
        let view = T()
        // 关闭自动约束转换，便于使用Auto Layout
        view.translatesAutoresizingMaskIntoConstraints = false
        // 执行配置闭包
        builder?(view)
        // 返回配置完成的视图
        return view
    }
    
    /// 获取或设置视图的宽度
    var zhWidth: CGFloat {
        get {
            return self.bounds.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// 获取或设置视图的高度
    var zhHeight: CGFloat {
        get {
            return self.bounds.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// 获取或设置视图的x坐标
    var zhX: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// 获取或设置视图的y坐标
    var zhY: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
}

#endif
