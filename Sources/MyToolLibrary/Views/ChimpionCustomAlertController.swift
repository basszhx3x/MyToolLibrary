import UIKit

/// ChimpionAlert配置结构体，用于配置Alert的外观和行为
public struct ChimpionAlertConfig {
    /// 容器视图的圆角大小
    public let cornerRadius: CGFloat
    
    /// 容器视图的阴影颜色
    public let shadowColor: UIColor
    
    /// 容器视图的阴影透明度
    public let shadowOpacity: Float
    
    /// 容器视图的阴影偏移
    public let shadowOffset: CGSize
    
    /// 容器视图的阴影半径
    public let shadowRadius: CGFloat
    
    /// 容器视图的背景颜色
    public let backgroundColor: UIColor
    
    /// 背景遮罩的透明度
    public let backgroundOpacity: CGFloat
    
    /// 是否允许点击外部区域关闭弹窗
    public let allowTapOutsideToDismiss: Bool
    
    /// 最小高度限制，当内容视图没有指定高度时使用
    public let minHeight: CGFloat
    
    /// 左右边距，当内容视图没有指定宽度时使用
    public let horizontalPadding: CGFloat
    
    /// 最大宽度限制，当内容视图没有指定宽度时使用
    public let maxWidth: CGFloat
    
    /// 最大高度限制，当内容视图没有指定高度时使用（相对于屏幕高度的百分比）
    public let maxHeightRatio: CGFloat
    
    /// 是否显示底部关闭按钮，默认不显示
    public let showCloseButton: Bool
    
    /// 关闭按钮文本，默认"关闭"
    public let closeButtonText: String
    
    /// 关闭按钮文本颜色，默认白色
    public let closeButtonTextColor: UIColor
    
    /// 关闭按钮背景颜色，默认灰色背景
    public let closeButtonBackgroundColor: UIColor
    
    /// 默认配置
    public static let `default` = ChimpionAlertConfig(
        cornerRadius: 12,
        shadowColor: .black,
        shadowOpacity: 0.2,
        shadowOffset: CGSize(width: 0, height: 2),
        shadowRadius: 8,
        backgroundColor: .white,
        backgroundOpacity: 0.5,
        allowTapOutsideToDismiss: true,
        minHeight: 300,
        horizontalPadding: 20,
        maxWidth: 400,
        maxHeightRatio: 0.8,
        showCloseButton: false,
        closeButtonText: "关闭",
        closeButtonTextColor: .white,
        closeButtonBackgroundColor: .systemBlue
    )
    
    /// 创建自定义配置
    /// - Parameters:
    ///   - cornerRadius: 圆角大小，默认12
    ///   - shadowColor: 阴影颜色，默认黑色
    ///   - shadowOpacity: 阴影透明度，默认0.2
    ///   - shadowOffset: 阴影偏移，默认(0, 2)
    ///   - shadowRadius: 阴影半径，默认8
    ///   - backgroundColor: 背景颜色，默认白色
    ///   - backgroundOpacity: 背景遮罩透明度，默认0.5
    ///   - allowTapOutsideToDismiss: 是否允许点击外部关闭，默认true
    ///   - minHeight: 最小高度，默认300
    ///   - horizontalPadding: 左右边距，默认20
    ///   - maxWidth: 最大宽度，默认400
    ///   - maxHeightRatio: 最大高度比例，默认0.8
    public init(
        cornerRadius: CGFloat = 12,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.2,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 8,
        backgroundColor: UIColor = .white,
        backgroundOpacity: CGFloat = 0.5,
        allowTapOutsideToDismiss: Bool = true,
        minHeight: CGFloat = 300,
        horizontalPadding: CGFloat = 20,
        maxWidth: CGFloat = 400,
        maxHeightRatio: CGFloat = 0.8,
        showCloseButton: Bool = false,
        closeButtonText: String = "关闭",
        closeButtonTextColor: UIColor = .white,
        closeButtonBackgroundColor: UIColor = .systemBlue
    ) {
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        self.allowTapOutsideToDismiss = allowTapOutsideToDismiss
        self.minHeight = minHeight
        self.horizontalPadding = horizontalPadding
        self.maxWidth = maxWidth
        self.maxHeightRatio = maxHeightRatio
        self.showCloseButton = showCloseButton
        self.closeButtonText = closeButtonText
        self.closeButtonTextColor = closeButtonTextColor
        self.closeButtonBackgroundColor = closeButtonBackgroundColor
    }
}

/// 自定义Alert类型控制器，支持显示外部传入的自定义视图
/// 自动处理视图的布局和尺寸，支持点击外部区域关闭
public class ChimpionCustomAlertController: UIViewController {
    
    // MARK: - Properties
    
    /// 外部传入的自定义内容视图
    private let contentView: UIView
    
    /// 配置对象
    private let config: ChimpionAlertConfig
    
    /// 背景遮罩视图
    private let backgroundView: UIView
    
    /// 容器视图，用于包裹内容视图并添加圆角和阴影
    private let containerView: UIView
    
    /// 关闭按钮（如果配置显示）
    private var closeButton: UIButton?
    
    /// 是否允许点击外部区域关闭弹窗
    public var allowTapOutsideToDismiss: Bool
    
    /// 最小高度限制，当内容视图没有指定高度时使用
    private var minHeight: CGFloat {
        return config.minHeight
    }
    
    /// 左右边距，当内容视图没有指定宽度时使用
    private var horizontalPadding: CGFloat {
        return config.horizontalPadding
    }
    
    /// 最大宽度限制
    private var maxWidth: CGFloat {
        return config.maxWidth
    }
    
    /// 最大高度比例
    private var maxHeightRatio: CGFloat {
        return config.maxHeightRatio
    }
    
    // MARK: - Initializers
    
    /// 初始化自定义Alert控制器
    /// - Parameters:
    ///   - contentView: 要显示的自定义内容视图
    ///   - config: 配置对象，使用默认配置可以不传
    public init(contentView: UIView, config: ChimpionAlertConfig = .default) {
        self.contentView = contentView
        self.config = config
        self.allowTapOutsideToDismiss = config.allowTapOutsideToDismiss
        
        // 初始化背景视图
        self.backgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(config.backgroundOpacity)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // 初始化容器视图
        self.containerView = {
            let view = UIView()
            view.backgroundColor = config.backgroundColor
            view.layer.cornerRadius = config.cornerRadius
            view.layer.shadowColor = config.shadowColor.cgColor
            view.layer.shadowOpacity = config.shadowOpacity
            view.layer.shadowOffset = config.shadowOffset
            view.layer.shadowRadius = config.shadowRadius
            view.clipsToBounds = true  // 启用裁剪，确保子视图不会超出圆角边界
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTapGesture()
    }
    
    // MARK: - Setup Methods
    
    /// 设置视图层次结构
    private func setupViews() {
        view.backgroundColor = .clear
        
        // 添加背景遮罩
        view.addSubview(backgroundView)
        
        // 添加容器视图
        view.addSubview(containerView)
        
        // 添加内容视图到容器中
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentView)
        
        // 如果配置显示关闭按钮，创建并添加关闭按钮
        if config.showCloseButton {
            createCloseButton()
        }
    }
    
    /// 创建关闭按钮
    private func createCloseButton() {
        closeButton = UIButton(type: .system)
        closeButton?.setTitle(config.closeButtonText, for: .normal)
        closeButton?.backgroundColor = config.closeButtonBackgroundColor
        closeButton?.setTitleColor(config.closeButtonTextColor, for: .normal)
        closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton?.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加点击事件
        closeButton?.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // 添加到容器视图
        if let closeButton = closeButton {
            containerView.addSubview(closeButton)
        }
    }
    
    /// 设置自动布局约束
    private func setupConstraints() {
        // 背景遮罩约束
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 容器视图约束
        var containerConstraints: [NSLayoutConstraint] = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        // 检查内容视图是否有固定宽度约束
        if let widthConstraint = findWidthConstraint(for: contentView) {
            // 如果内容视图有固定宽度，使用它
            containerConstraints.append(
                containerView.widthAnchor.constraint(equalToConstant: widthConstraint.constant)
            )
        } else {
            // 否则设置最大宽度，考虑左右边距
            let calculatedMaxWidth = min(view.bounds.width - (horizontalPadding * 2), maxWidth)
            containerConstraints.append(
                containerView.widthAnchor.constraint(equalToConstant: calculatedMaxWidth)
            )
        }
        
        // 检查内容视图是否有固定高度约束
        if let heightConstraint = findHeightConstraint(for: contentView) {
            // 如果内容视图有固定高度，使用它
            containerConstraints.append(
                containerView.heightAnchor.constraint(equalToConstant: heightConstraint.constant)
            )
        } else {
            // 否则设置最小高度为300
            containerConstraints.append(
                containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            )
            // 同时限制最大高度不超过屏幕高度的指定比例
            containerConstraints.append(
                containerView.heightAnchor.constraint(lessThanOrEqualToConstant: view.bounds.height * maxHeightRatio)
            )
        }
        
        NSLayoutConstraint.activate(containerConstraints)
        
        // 内容视图约束
        if config.showCloseButton, let closeButton = closeButton {
            // 有关闭按钮的情况
            NSLayoutConstraint.activate([
                // 内容视图约束
                contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: closeButton.topAnchor),
                
                // 关闭按钮约束
                closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                closeButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        } else {
            // 没有关闭按钮的情况
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }
    
    /// 设置点击手势识别器
    private func setupTapGesture() {
        // 添加点击外部区域关闭的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helper Methods
    
    /// 查找视图的宽度约束
    /// - Parameter view: 要查找约束的视图
    /// - Returns: 如果找到宽度约束则返回，否则返回nil
    private func findWidthConstraint(for view: UIView) -> NSLayoutConstraint? {
        // 检查视图自身的约束
        for constraint in view.constraints {
            if constraint.firstAttribute == .width && constraint.relation == .equal {
                return constraint
            }
        }
        
        // 检查框架是否有明确的宽度设置（非零且非CGRectZero）
        if view.frame.width > 0 && !view.frame.equalTo(.zero) {
            // 创建一个基于框架宽度的临时约束
            return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width)
        }
        
        // 检查intrinsicContentSize
        if view.intrinsicContentSize.width > 0 && view.intrinsicContentSize.width != UIView.noIntrinsicMetric {
            return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.intrinsicContentSize.width)
        }
        
        return nil
    }
    
    /// 查找视图的高度约束
    /// - Parameter view: 要查找约束的视图
    /// - Returns: 如果找到高度约束则返回，否则返回nil
    private func findHeightConstraint(for view: UIView) -> NSLayoutConstraint? {
        // 检查视图自身的约束
        for constraint in view.constraints {
            if constraint.firstAttribute == .height && constraint.relation == .equal {
                return constraint
            }
        }
        
        // 检查框架是否有明确的高度设置（非零且非CGRectZero）
        if view.frame.height > 0 && !view.frame.equalTo(.zero) {
            // 创建一个基于框架高度的临时约束
            return NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.height)
        }
        
        // 检查intrinsicContentSize
        if view.intrinsicContentSize.height > 0 && view.intrinsicContentSize.height != UIView.noIntrinsicMetric {
            return NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.intrinsicContentSize.height)
        }
        
        return nil
    }
    
    // MARK: - Actions
    
    /// 处理关闭按钮点击事件
    @objc private func closeButtonTapped() {
        dismissAlert()
    }
    
    /// 处理点击外部区域的事件
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        guard allowTapOutsideToDismiss else { return }
        
        let location = gesture.location(in: view)
        
        // 检查点击位置是否在容器视图外部
        if !containerView.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Public Methods
    
    /// 显示Alert
    /// - Parameter presentingController: 要展示此Alert的控制器
    public func show(in presentingController: UIViewController) {
        presentingController.present(self, animated: true, completion: nil)
    }
    
    /// 关闭Alert
    public func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 更新内容视图的布局
    /// 如果内容视图的大小发生变化，可以调用此方法重新计算布局
    public func updateLayout() {
        // 移除现有的宽度和高度约束
        containerView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                containerView.removeConstraint(constraint)
            }
        }
        
        // 重新添加约束
        setupConstraints()
        
        // 触发布局更新
        view.layoutIfNeeded()
    }
}

// MARK: - Convenience Extension

extension UIViewController {
    /// 便捷方法：显示自定义Alert
    /// - Parameters:
    ///   - contentView: 要显示的自定义内容视图
    ///   - config: 配置对象，使用默认配置可以不传
    /// - Returns: 创建的ChimpionAlertController实例
    @discardableResult
    public func showChimpionAlert(contentView: UIView, config: ChimpionAlertConfig = .default) -> ChimpionCustomAlertController {
        let alertController = ChimpionCustomAlertController(contentView: contentView, config: config)
        alertController.show(in: self)
        return alertController
    }
    
    /// 便捷方法：显示自定义Alert（兼容旧版API）
    /// - Parameters:
    ///   - contentView: 要显示的自定义内容视图
    ///   - allowTapOutsideToDismiss: 是否允许点击外部关闭，默认为true
    /// - Returns: 创建的ChimpionAlertController实例
    @discardableResult
    public func showChimpionAlert(contentView: UIView, allowTapOutsideToDismiss: Bool = true) -> ChimpionCustomAlertController {
        // 创建新的配置对象，修改允许点击外部关闭的属性
        let config = ChimpionAlertConfig(
            cornerRadius: ChimpionAlertConfig.default.cornerRadius,
            shadowColor: ChimpionAlertConfig.default.shadowColor,
            shadowOpacity: ChimpionAlertConfig.default.shadowOpacity,
            shadowOffset: ChimpionAlertConfig.default.shadowOffset,
            shadowRadius: ChimpionAlertConfig.default.shadowRadius,
            backgroundColor: ChimpionAlertConfig.default.backgroundColor,
            backgroundOpacity: ChimpionAlertConfig.default.backgroundOpacity,
            allowTapOutsideToDismiss: allowTapOutsideToDismiss,
            minHeight: ChimpionAlertConfig.default.minHeight,
            horizontalPadding: ChimpionAlertConfig.default.horizontalPadding,
            maxWidth: ChimpionAlertConfig.default.maxWidth,
            maxHeightRatio: ChimpionAlertConfig.default.maxHeightRatio,
            showCloseButton: ChimpionAlertConfig.default.showCloseButton,
            closeButtonText: ChimpionAlertConfig.default.closeButtonText,
            closeButtonTextColor: ChimpionAlertConfig.default.closeButtonTextColor,
            closeButtonBackgroundColor: ChimpionAlertConfig.default.closeButtonBackgroundColor
        )
        
        let alertController = ChimpionCustomAlertController(contentView: contentView, config: config)
        alertController.show(in: self)
        return alertController
    }
}
