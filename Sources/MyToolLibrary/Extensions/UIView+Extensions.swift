#if canImport(UIKit)
import UIKit

public extension UIView {
    /// 添加圆角
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 添加边框
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
    }
    
    /// 添加阴影
    func addShadow(color: UIColor = .black, 
                   opacity: Float = 0.5, 
                   offset: CGSize = CGSize(width: 0, height: 2), 
                   radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

public extension UIView {
    /// Convenience function to ease creating new views.
    ///
    /// Calling this function creates a new view with `translatesAutoresizingMaskIntoConstraints`
    /// set to false. Passing in an optional closure to do further configuration of the view.
    ///
    /// - Parameter builder: A function that takes the newly created view.
    ///
    /// Usage:
    /// ```
    ///    private let button: UIButton = .build { button in
    ///        button.setTitle("Tap me!", for state: .normal)
    ///        button.backgroundColor = .systemPink
    ///    }
    /// ```
    static func build<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)

        return view
    }

}

#endif
