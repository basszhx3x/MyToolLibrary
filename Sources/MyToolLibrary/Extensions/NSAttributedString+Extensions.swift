//
//  NSAttributedString+Extensions.swift
//  MyToolLibrary
//
//  Created by basszhx3x on 2024/10/12.
//

import UIKit

/// NSAttributedString扩展
/// 
/// 提供便捷的富文本创建和样式设置方法
public extension NSAttributedString {
    
    /// 创建带有颜色和字体的富文本
    /// - Parameters:
    ///   - string: 文本内容
    ///   - color: 文本颜色
    ///   - font: 文本字体
    convenience init(string: String, color: UIColor, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        self.init(string: string, attributes: attributes)
    }
    
    /// 创建带有文本样式的富文本
    /// - Parameters:
    ///   - string: 文本内容
    ///   - style: 文本样式
    convenience init(string: String, style: UIFont.TextStyle) {
        let font = UIFont.preferredFont(forTextStyle: style)
        self.init(string: string, font: font)
    }
    
    /// 创建带有指定字体的富文本
    /// - Parameters:
    ///   - string: 文本内容
    ///   - font: 文本字体
    convenience init(string: String, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        self.init(string: string, attributes: attributes)
    }
    
    /// 添加文本颜色
    /// - Parameter color: 文本颜色
    /// - Returns: 添加了颜色属性的新富文本
    func addingColor(_ color: UIColor) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: NSRange(location: 0, length: length)
        )
        return mutableAttributedString
    }
    
    /// 添加字体
    /// - Parameter font: 文本字体
    /// - Returns: 添加了字体属性的新富文本
    func addingFont(_ font: UIFont) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttribute(
            .font,
            value: font,
            range: NSRange(location: 0, length: length)
        )
        return mutableAttributedString
    }
    
    /// 添加下划线
    /// - Parameters:
    ///   - style: 下划线样式
    ///   - color: 下划线颜色，默认为文本颜色
    /// - Returns: 添加了下划线属性的新富文本
    func addingUnderline(style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        // 添加下划线样式
        mutableAttributedString.addAttribute(
            .underlineStyle,
            value: style.rawValue,
            range: NSRange(location: 0, length: length)
        )
        
        // 如果指定了下划线颜色，则添加颜色属性
        if let underlineColor = color {
            mutableAttributedString.addAttribute(
                .underlineColor,
                value: underlineColor,
                range: NSRange(location: 0, length: length)
            )
        }
        
        return mutableAttributedString
    }
    
    /// 添加中划线
    /// - Parameter color: 中划线颜色，默认为文本颜色
    /// - Returns: 添加了中划线属性的新富文本
    func addingStrikethrough(color: UIColor? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        // 添加中划线样式
        mutableAttributedString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: length)
        )
        
        // 如果指定了中划线颜色，则添加颜色属性
        if let strikethroughColor = color {
            mutableAttributedString.addAttribute(
                .strikethroughColor,
                value: strikethroughColor,
                range: NSRange(location: 0, length: length)
            )
        }
        
        return mutableAttributedString
    }
    
    /// 添加文字间距
    /// - Parameter kern: 字间距值
    /// - Returns: 添加了字间距属性的新富文本
    func addingKern(_ kern: CGFloat) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttribute(
            .kern,
            value: kern,
            range: NSRange(location: 0, length: length)
        )
        return mutableAttributedString
    }
    
    /// 添加行间距
    /// - Parameter lineSpacing: 行间距值
    /// - Returns: 添加了行间距属性的新富文本
    func addingLineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        mutableAttributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: length)
        )
        return mutableAttributedString
    }
    
    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 设置了对齐方式的新富文本
    func settingAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        mutableAttributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: length)
        )
        return mutableAttributedString
    }
    
    /// 计算富文本在指定最大尺寸下的实际尺寸
    /// - Parameter maxSize: 最大允许尺寸
    /// - Returns: 富文本的实际尺寸
    func sizeThatFits(_ maxSize: CGSize) -> CGSize {
        let boundingRect = boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
    }
    
    /// 将多个富文本连接起来
    /// - Parameter attributedString: 要连接的富文本
    /// - Returns: 连接后的新富文本
    func appending(_ attributedString: NSAttributedString) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.append(attributedString)
        return mutableAttributedString
    }
}

// MARK: - 链式调用支持

public extension NSAttributedString {
    /// 链式调用：设置文本颜色
    @discardableResult
    func color(_ color: UIColor) -> NSAttributedString {
        return addingColor(color)
    }
    
    /// 链式调用：设置文本字体
    @discardableResult
    func font(_ font: UIFont) -> NSAttributedString {
        return addingFont(font)
    }
    
    /// 链式调用：设置下划线
    @discardableResult
    func underline(style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString {
        return addingUnderline(style: style, color: color)
    }
    
    /// 链式调用：设置中划线
    @discardableResult
    func strikethrough(color: UIColor? = nil) -> NSAttributedString {
        return addingStrikethrough(color: color)
    }
    
    /// 链式调用：设置字间距
    @discardableResult
    func kern(_ kern: CGFloat) -> NSAttributedString {
        return addingKern(kern)
    }
    
    /// 链式调用：设置行间距
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        return addingLineSpacing(lineSpacing)
    }
    
    /// 链式调用：设置文本对齐方式
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        return settingAlignment(alignment)
    }
}

// MARK: - 便捷构造方法扩展

public extension NSMutableAttributedString {
    /// 添加文本样式到指定范围
    /// - Parameters:
    ///   - attributes: 文本属性字典
    ///   - range: 应用属性的文本范围
    /// - Returns: 应用了属性的自身实例
    @discardableResult
    func applyingAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) -> NSMutableAttributedString {
        self.addAttributes(attributes, range: range)
        return self
    }
    
    /// 添加文本颜色到指定范围
    /// - Parameters:
    ///   - color: 文本颜色
    ///   - range: 应用颜色的文本范围
    /// - Returns: 应用了颜色的自身实例
    @discardableResult
    func addColor(_ color: UIColor, range: NSRange) -> NSMutableAttributedString {
        addAttribute(.foregroundColor, value: color, range: range)
        return self
    }
    
    /// 添加文本字体到指定范围
    /// - Parameters:
    ///   - font: 文本字体
    ///   - range: 应用字体的文本范围
    /// - Returns: 应用了字体的自身实例
    @discardableResult
    func addFont(_ font: UIFont, range: NSRange) -> NSMutableAttributedString {
        addAttribute(.font, value: font, range: range)
        return self
    }
    /// 查找并修改文本颜色
    /// - Parameters:
    ///   - searchText: 要查找的文本
    ///   - highlightColor: 高亮背景颜色
    /// - Returns: 高亮后的自身实例
    @discardableResult
    func colorAll(occurrencesOf searchText: String, withColor highlightColor: UIColor) -> NSMutableAttributedString {
        let fullText = string as NSString
        var searchRange = NSRange(location: 0, length: fullText.length)
        var foundRange: NSRange
        
        while true {
            foundRange = fullText.range(of: searchText, options: [], range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }
            
            addAttribute(.foregroundColor, value: highlightColor, range: foundRange)
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = fullText.length - searchRange.location
            
            if searchRange.location >= fullText.length {
                break
            }
        }
        
        return self
    }
    
    /// 查找并高亮指定文本
    /// - Parameters:
    ///   - searchText: 要查找的文本
    ///   - highlightColor: 高亮背景颜色
    /// - Returns: 高亮后的自身实例
    @discardableResult
    func highlight(text searchText: String, withColor highlightColor: UIColor) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: searchText)
        if range.location != NSNotFound {
            addAttribute(.backgroundColor, value: highlightColor, range: range)
        }
        return self
    }
    
    /// 查找并高亮所有指定文本
    /// - Parameters:
    ///   - searchText: 要查找的文本
    ///   - highlightColor: 高亮背景颜色
    /// - Returns: 高亮后的自身实例
    @discardableResult
    func highlightAll(occurrencesOf searchText: String, withColor highlightColor: UIColor) -> NSMutableAttributedString {
        let fullText = string as NSString
        var searchRange = NSRange(location: 0, length: fullText.length)
        var foundRange: NSRange
        
        while true {
            foundRange = fullText.range(of: searchText, options: [], range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }
            
            addAttribute(.backgroundColor, value: highlightColor, range: foundRange)
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = fullText.length - searchRange.location
            
            if searchRange.location >= fullText.length {
                break
            }
        }
        
        return self
    }
}
