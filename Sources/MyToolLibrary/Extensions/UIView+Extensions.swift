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
#endif