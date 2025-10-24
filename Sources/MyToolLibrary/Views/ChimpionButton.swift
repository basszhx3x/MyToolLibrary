import UIKit

// 图标位置枚举
public enum ImagePosition {
    case left   // 图标在标题左侧
    case right  // 图标在标题右侧
    case top    // 图标在标题上方
    case bottom // 图标在标题下方
}

public class ChimpionButton: UIButton {
    
    // MARK: - 公共属性
    
    /// 按钮配置
    private(set) var buttonConfiguration: UIButton.Configuration
    
    // MARK: - 初始化
    
    /// 使用指定的frame初始化按钮
    /// - Parameter frame: 按钮的初始框架
    public override init(frame: CGRect) {
        // 初始化按钮配置
        buttonConfiguration = UIButton.Configuration.plain()
        super.init(frame: frame)
        commonInit()
    }
    
    /// 使用编码器初始化按钮（用于Storyboard或XIB）
    /// - Parameter coder: NSCoder对象
    required public init?(coder: NSCoder) {
        // 初始化按钮配置
        buttonConfiguration = UIButton.Configuration.plain()
        super.init(coder: coder)
        commonInit()
    }
    
    /// 图标位置，默认为左侧
    /// - 支持左、右、上、下四种位置布局
    public var imagePosition: ImagePosition = .left {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 图标与标题之间的间距，默认为8
    /// - 此属性控制图片和文字之间的距离
    public var spacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 图片的最大尺寸，如果为 nil 则使用图片原始尺寸
    /// - 默认值为 30x30 像素
    /// - 设置为零或负值时将自动置为 nil
    public var maxImageSize: CGSize? = CGSize(width: 30, height: 30) {
        didSet {
            // 确保 maxImageSize 不是零或负值
            if let size = maxImageSize, size.width <= 0 || size.height <= 0 {
                maxImageSize = nil
            }
            setNeedsLayout()
        }
    }
    
    /// 图片缩放模式，默认为按比例缩放适应
    /// - 控制图片在容器内的显示方式
    public var imageScaleMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            imageView?.contentMode = imageScaleMode
            setNeedsLayout()
        }
    }
    
    /// 内容边距
    /// - 控制按钮内容（图片和文字）与按钮边界之间的距离
    /// - 使用NSDirectionalEdgeInsets以支持RTL布局
    public var contentInsets: NSDirectionalEdgeInsets = .zero {
        didSet {
            buttonConfiguration.contentInsets = contentInsets
            setNeedsLayout()
        }
    }
    
    // MARK: - 私有属性
    
    private var calculatedImageSize: CGSize = .zero
    
    /// 通用初始化方法
    /// - 设置按钮的基本属性和初始配置
    /// - 配置标题标签和图片视图的基本行为
    private func commonInit() {
        // 设置配置
        configuration = buttonConfiguration
        
        // 确保标题和图片内容正确显示
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 1
        titleLabel?.lineBreakMode = .byTruncatingTail
        imageView?.contentMode = imageScaleMode
        imageView?.clipsToBounds = true
    }
    
    // MARK: - 布局
    
    /// 重写布局子视图方法，根据图片位置对按钮内容进行自定义布局
    /// - 处理图片和文字的位置关系，支持左、右、上、下四种布局方式
    /// - 自动处理内容的居中对齐和间距调整
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 安全检查：确保imageView和titleLabel存在
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        // 确保有图片或标题时才进行调整
        if imageView.image == nil && titleLabel.text == nil { return }
        
        // 获取配置中的内容边距
        let insets = buttonConfiguration.contentInsets
        
        // 计算可用的内容区域（减去内边距）
        let contentRect = bounds.inset(
            by: UIEdgeInsets(
                top: insets.top, 
                left: insets.leading, 
                bottom: insets.bottom, 
                right: insets.trailing
            )
        )
        
        // 确保内容区域有效
        guard contentRect.width > 0 && contentRect.height > 0 else { return }
        
        // 计算图片的显示尺寸
        let imageSize = calculateImageSize(availableSize: contentRect.size)
        calculatedImageSize = imageSize
        
        // 计算标题的显示尺寸
        let titleSize = calculateTitleSize(availableSize: contentRect.size, imageSize: imageSize)
        
        // 根据图片位置调用对应的布局方法
        switch imagePosition {
        case .left:
            layoutImageLeft(contentRect: contentRect, titleSize: titleSize, imageSize: imageSize)
        case .right:
            layoutImageRight(contentRect: contentRect, titleSize: titleSize, imageSize: imageSize)
        case .top:
            layoutImageTop(contentRect: contentRect, titleSize: titleSize, imageSize: imageSize)
        case .bottom:
            layoutImageBottom(contentRect: contentRect, titleSize: titleSize, imageSize: imageSize)
        }
    }
    
    /// 重写计算按钮的固有内容尺寸
    /// - 根据图片位置、尺寸、标题尺寸和间距计算按钮的最小所需尺寸
    /// - 确保按钮能够完整显示所有内容
    /// - Returns: 按钮的最小所需尺寸
    public override var intrinsicContentSize: CGSize {
        // 安全检查：确保imageView和titleLabel存在
        guard let _ = imageView, let titleLabel = titleLabel else {
            return super.intrinsicContentSize
        }
        
        // 计算图片的显示尺寸
        let imageSize = calculateImageSize(availableSize: bounds.size)
        // 获取标题的固有尺寸
        let titleSize = titleLabel.intrinsicContentSize
        
        // 获取配置中的内容边距
        let insets = buttonConfiguration.contentInsets
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        // 根据图片位置计算不同的尺寸
        switch imagePosition {
        case .left, .right: // 水平布局
            width = imageSize.width + titleSize.width + spacing + insets.leading + insets.trailing
            height = max(imageSize.height, titleSize.height) + insets.top + insets.bottom
        case .top, .bottom: // 垂直布局
            width = max(imageSize.width, titleSize.width) + insets.leading + insets.trailing
            height = imageSize.height + titleSize.height + spacing + insets.top + insets.bottom
        }
        
        // 确保返回的尺寸有效（非负数）
        return CGSize(width: max(width, 0), height: max(height, 0))
    }
    
    // MARK: - 尺寸计算
    
    /// 计算图片在可用空间内的最佳显示尺寸
    /// - Parameter availableSize: 可用空间的尺寸
    /// - Returns: 计算后的图片尺寸
    /// - 处理逻辑：
    ///   1. 安全检查确保输入有效
    ///   2. 应用maxImageSize限制（如果设置）
    ///   3. 根据布局方向计算最大可用空间
    ///   4. 按比例缩放图片以适应空间
    private func calculateImageSize(availableSize: CGSize) -> CGSize {
        // 安全检查：确保availableSize有效
        guard availableSize.width > 0 && availableSize.height > 0 else { return .zero }
        guard let image = imageView?.image else { return .zero }
        
        // 确保image.size有效
        guard image.size.width > 0 && image.size.height > 0 else { return .zero }
        
        var imageSize = image.size
        
        // 如果设置了最大图片尺寸，则进行缩放
        if let maxSize = maxImageSize, maxSize.width > 0, maxSize.height > 0 {
            imageSize = scaleImageSize(originalSize: imageSize, toFit: maxSize)
        } else {
            // 根据可用空间自动缩放图片
            let maxAvailableSize: CGSize
            switch imagePosition {
            case .left, .right:
                // 水平布局时，图片高度不超过可用高度
                let safeWidth = max(availableSize.width * 0.5, 0)
                let safeHeight = max(availableSize.height, 0)
                maxAvailableSize = CGSize(width: safeWidth, height: safeHeight)
            case .top, .bottom:
                // 垂直布局时，图片宽度不超过可用宽度
                let safeWidth = max(availableSize.width, 0)
                let safeHeight = max(availableSize.height * 0.5, 0)
                maxAvailableSize = CGSize(width: safeWidth, height: safeHeight)
            }
            
            // 只在需要时缩放
            if maxAvailableSize.width > 0 && maxAvailableSize.height > 0 {
                imageSize = scaleImageSize(originalSize: imageSize, toFit: maxAvailableSize)
            }
        }
        
        // 确保返回的尺寸有效
        return CGSize(width: max(imageSize.width, 0), height: max(imageSize.height, 0))
    }
    
    /// 计算标题在可用空间内的最佳显示尺寸
    /// - Parameters:
    ///   - availableSize: 可用空间的尺寸
    ///   - imageSize: 图片占用的尺寸
    /// - Returns: 计算后的标题尺寸
    /// - 根据图片位置计算剩余可用空间，并确保标题不会超出边界
    private func calculateTitleSize(availableSize: CGSize, imageSize: CGSize) -> CGSize {
        guard let titleLabel = titleLabel else { return .zero }
        
        let maxTitleSize: CGSize
        switch imagePosition {
        case .left, .right:
            // 水平布局时，标题宽度为可用宽度减去图片宽度和间距
            let availableWidth = max(availableSize.width - imageSize.width - spacing, 0)
            maxTitleSize = CGSize(
                width: availableWidth,
                height: max(availableSize.height, 0)
            )
        case .top, .bottom:
            // 垂直布局时，标题宽度不超过可用宽度，高度为剩余高度
            let availableHeight = max(availableSize.height - imageSize.height - spacing, 0)
            maxTitleSize = CGSize(
                width: max(availableSize.width, 0),
                height: availableHeight
            )
        }
        
        // 确保尺寸有效
        guard maxTitleSize.width > 0 && maxTitleSize.height > 0 else {
            return titleLabel.intrinsicContentSize
        }
        
        var titleSize = titleLabel.sizeThatFits(maxTitleSize)
        
        // 确保标题尺寸不超过最大可用空间
        titleSize.width = min(titleSize.width, maxTitleSize.width)
        titleSize.height = min(titleSize.height, maxTitleSize.height)
        
        // 确保返回的尺寸有效
        return CGSize(width: max(titleSize.width, 0), height: max(titleSize.height, 0))
    }
    
    /// 按比例缩放图片尺寸以适应目标尺寸
    /// - Parameters:
    ///   - originalSize: 原始图片尺寸
    ///   - maxSize: 最大允许尺寸
    /// - Returns: 缩放后的图片尺寸
    /// - 保持原始图片的宽高比，仅在需要时进行缩放
    private func scaleImageSize(originalSize: CGSize, toFit maxSize: CGSize) -> CGSize {
        // 严格的安全检查，确保所有尺寸都是有效正数
        guard originalSize.width > 0 && originalSize.height > 0 && 
              maxSize.width > 0 && maxSize.height > 0 else {
            return CGSize(width: max(originalSize.width, 0), height: max(originalSize.height, 0))
        }
        
        // 只在需要时缩放
        if originalSize.width <= maxSize.width && originalSize.height <= maxSize.height {
            return originalSize
        }
        
        // 计算缩放比例，避免除以零和负数问题
        let widthRatio = maxSize.width / originalSize.width
        let heightRatio = maxSize.height / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        // 确保缩放后的尺寸有效
        let scaledWidth = max(originalSize.width * scaleFactor, 0)
        let scaledHeight = max(originalSize.height * scaleFactor, 0)
        
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
    // MARK: - 私有布局方法
    
    /// 处理图片在左侧的布局
    /// - Parameters:
    ///   - contentRect: 内容区域
    ///   - titleSize: 标题尺寸
    ///   - imageSize: 图片尺寸
    /// - 图片在左，文字在右，两者垂直居中对齐
    private func layoutImageLeft(contentRect: CGRect, titleSize: CGSize, imageSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let totalWidth = imageSize.width + spacing + titleSize.width
        let startX = contentRect.minX + max((contentRect.width - totalWidth) / 2, 0)
        let centerY = contentRect.midY
        
        imageView.frame = CGRect(
            x: startX,
            y: centerY - imageSize.height / 2,
            width: max(imageSize.width, 0),
            height: max(imageSize.height, 0)
        )
        
        titleLabel.frame = CGRect(
            x: startX + imageSize.width + spacing,
            y: centerY - titleSize.height / 2,
            width: max(titleSize.width, 0),
            height: max(titleSize.height, 0)
        )
    }
    
    /// 处理图片在右侧的布局
    /// - Parameters:
    ///   - contentRect: 内容区域
    ///   - titleSize: 标题尺寸
    ///   - imageSize: 图片尺寸
    /// - 文字在左，图片在右，两者垂直居中对齐
    private func layoutImageRight(contentRect: CGRect, titleSize: CGSize, imageSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let totalWidth = imageSize.width + spacing + titleSize.width
        let startX = contentRect.minX + max((contentRect.width - totalWidth) / 2, 0)
        let centerY = contentRect.midY
        
        titleLabel.frame = CGRect(
            x: startX,
            y: centerY - titleSize.height / 2,
            width: max(titleSize.width, 0),
            height: max(titleSize.height, 0)
        )
        
        imageView.frame = CGRect(
            x: startX + titleSize.width + spacing,
            y: centerY - imageSize.height / 2,
            width: max(imageSize.width, 0),
            height: max(imageSize.height, 0)
        )
    }
    
    /// 处理图片在上侧的布局
    /// - Parameters:
    ///   - contentRect: 内容区域
    ///   - titleSize: 标题尺寸
    ///   - imageSize: 图片尺寸
    /// - 图片在上，文字在下，两者水平居中对齐
    private func layoutImageTop(contentRect: CGRect, titleSize: CGSize, imageSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let totalHeight = imageSize.height + spacing + titleSize.height
        let startY = contentRect.minY + max((contentRect.height - totalHeight) / 2, 0)
        let centerX = contentRect.midX
        
        imageView.frame = CGRect(
            x: centerX - imageSize.width / 2,
            y: startY,
            width: max(imageSize.width, 0),
            height: max(imageSize.height, 0)
        )
        
        titleLabel.frame = CGRect(
            x: centerX - titleSize.width / 2,
            y: startY + imageSize.height + spacing,
            width: max(titleSize.width, 0),
            height: max(titleSize.height, 0)
        )
    }
    
    /// 处理图片在下侧的布局
    /// - Parameters:
    ///   - contentRect: 内容区域
    ///   - titleSize: 标题尺寸
    ///   - imageSize: 图片尺寸
    /// - 文字在上，图片在下，两者水平居中对齐
    private func layoutImageBottom(contentRect: CGRect, titleSize: CGSize, imageSize: CGSize) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let totalHeight = imageSize.height + spacing + titleSize.height
        let startY = contentRect.minY + max((contentRect.height - totalHeight) / 2, 0)
        let centerX = contentRect.midX
        
        titleLabel.frame = CGRect(
            x: centerX - titleSize.width / 2,
            y: startY,
            width: max(titleSize.width, 0),
            height: max(titleSize.height, 0)
        )
        
        imageView.frame = CGRect(
            x: centerX - imageSize.width / 2,
            y: startY + titleSize.height + spacing,
            width: max(imageSize.width, 0),
            height: max(imageSize.height, 0)
        )
    }
    
    // MARK: - 便捷方法
    
    /// 设置按钮内容
    /// - Parameters:
    ///   - title: 标题
    ///   - image: 图片
    ///   - position: 图片位置
    ///   - spacing: 间距
    ///   - maxImageSize: 图片最大尺寸
    public func set(title: String?, image: UIImage?, position: ImagePosition = .left, spacing: CGFloat = 8, maxImageSize: CGSize? = nil) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        self.imagePosition = position
        self.spacing = spacing
        
        // 安全设置 maxImageSize
        if let size = maxImageSize, size.width > 0 && size.height > 0 {
            self.maxImageSize = size
        } else {
            self.maxImageSize = nil
        }
        
        setNeedsLayout()
    }
    
    /// 设置图片最大尺寸
    /// - Parameters:
    ///   - width: 图片最大宽度
    ///   - height: 图片最大高度
    /// - 当宽度或高度小于等于零时，将移除图片大小限制
    public func setMaxImageSize(width: CGFloat, height: CGFloat) {
        if width > 0 && height > 0 {
            maxImageSize = CGSize(width: width, height: height)
        } else {
            maxImageSize = nil
        }
        setNeedsLayout()
    }
    
    /// 移除图片大小限制
    /// - 设置图片使用原始尺寸（可能会根据可用空间自动缩放）
    public func removeMaxImageSize() {
        maxImageSize = nil
        setNeedsLayout()
    }
}
