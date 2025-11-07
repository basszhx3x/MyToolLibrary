// 根据平台导入相应的框架
import UIKit

// iOS/tvOS版本的自定义AlertController - 基于UIViewController完全自定义实现
public class ChimpionAlertController: UIViewController {
    // MARK: - 窗口相关属性
    private var alertWindow: UIWindow?
    private var alertWindowScene: UIWindowScene?
    
    // MARK: - 静态样式常量
    
    // MARK: - 样式常量
    public static var alert: Int { 0 }  // 弹窗样式
    public static var sheet: Int { 1 }  // 底部弹出样式
    
    // MARK: - 属性
    
    // 弹窗内容相关
    private var titleText: String?
    private var messageText: String?
    
    // 样式相关
    private var titleFont: UIFont? = UIFont.boldSystemFont(ofSize: 17)
    private var titleColor: UIColor? = .black
    private var messageFont: UIFont? = UIFont.systemFont(ofSize: 15)
    private var messageColor: UIColor? = .darkGray
    private var buttonStyles: [Int: (font: UIFont, color: UIColor)] = [:]
    
    // 按钮和处理器相关
    private var alertActions: [ChimpionAlertAction] = []
    
    // 视图组件
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = titleFont
        label.textColor = titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = messageFont
        label.textColor = messageColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        // 默认设置为水平方向，将在setupUI中根据样式动态调整
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - 初始化方法
    
    // 记录当前样式
    private let preferredStyle: Int
    
    public init(title: String?, message: String?, preferredStyle: Int) {
        self.titleText = title
        self.messageText = message
        self.preferredStyle = preferredStyle
        super.init(nibName: nil, bundle: nil)
        
        // 半透明背景
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期方法
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        
        // Set preferred max layout width for better text wrapping
        titleLabel.preferredMaxLayoutWidth = 260 // 300 - 2*20 padding
        messageLabel.preferredMaxLayoutWidth = 260 // 300 - 2*20 padding
    }
    
    // MARK: - UI设置方法
    
    private func setupUI() {
        // 添加容器视图
        view.addSubview(containerView)
        
        // 根据样式设置stackView的axis属性
        if preferredStyle == ChimpionAlertController.sheet {
            buttonStackView.axis = .vertical
        } else {
            buttonStackView.axis = .horizontal
        }
        
        // 根据样式设置容器视图约束
        if preferredStyle == ChimpionAlertController.sheet {
            // Sheet模式布局 - 底部弹出，适配刘海屏，自适应高度
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor) // 允许根据内容自适应高度
            ])
            
            // Sheet模式下添加圆角到顶部
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.layer.cornerRadius = 14
        } else {
            // Alert模式布局 - 居中显示，固定宽度300
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containerView.widthAnchor.constraint(equalToConstant: 300)
            ])
        }
        
        // 添加标题标签
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        // 添加消息标签
        containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        // 设置内容压缩阻力优先级，确保标题和消息能够完整显示
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // 添加按钮栈视图
        containerView.addSubview(buttonStackView)
        
        // 基础约束
        var buttonConstraints: [NSLayoutConstraint] = [
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]
        
        // 根据样式调整按钮布局
        if preferredStyle == ChimpionAlertController.sheet {
            // Sheet模式下按钮垂直排列
            buttonStackView.axis = .vertical
            buttonStackView.distribution = .fill
            buttonStackView.spacing = 0
            
            // 根据是否有标题和消息来设置按钮的顶部约束
           
            if let mess = messageText,!mess.isEmpty,titleText == nil {
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8))
            }
            else if let mess = messageText,!mess.isEmpty, let title = titleText,title.isEmpty{
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8))
            }
            else if let title = titleText,!title.isEmpty,messageText == nil {
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8))
            }
            else if let title = titleText,!title.isEmpty,let mess = messageText,mess.isEmpty {
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8))
            }
            else if let mess = messageText,!mess.isEmpty,let title = titleText,!title.isEmpty {
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8))
            }
            else {
                buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8))
            }

            buttonConstraints.append(buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16))
        } else {
            // Alert模式下按钮水平排列
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fillProportionally
            buttonStackView.spacing = 0
            
            // 不需要为栈视图设置固定高度，因为每个按钮已经有高度约束
            buttonConstraints.append(buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20))
            buttonConstraints.append(buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0))
        }
        
        NSLayoutConstraint.activate(buttonConstraints)
        
        // 确保按钮区域有足够的显示空间
        buttonStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        // 添加点击背景关闭手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateUI() {
        titleLabel.text = titleText
        messageLabel.text = messageText
        updateButtonViews()
        
        // 处理Sheet模式下动态更新title和message时的按钮约束
        if preferredStyle == ChimpionAlertController.sheet {
            // 查找并移除现有的按钮顶部约束
            NSLayoutConstraint.deactivate(buttonStackView.constraints.filter {
                $0.firstAnchor == buttonStackView.topAnchor &&
                ($0.secondAnchor == messageLabel.bottomAnchor || $0.secondAnchor == containerView.topAnchor)
            })
            
            if let mess = messageText,!mess.isEmpty,titleText == nil {
                buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8).isActive = true
            }
            else if let mess = messageText,!mess.isEmpty, let title = titleText,title.isEmpty{
                buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8).isActive = true
            }
            else if let title = titleText,!title.isEmpty,messageText == nil {
                buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            }
            else if let title = titleText,!title.isEmpty,let mess = messageText,mess.isEmpty {
                buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            }
            else if let mess = messageText,!mess.isEmpty,let title = titleText,!title.isEmpty {
                buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8).isActive = true
            }
            else {
                // 有标题或消息时，按钮距离消息标签底部8pt
                buttonStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
            }
            
        }
        
        // 强制布局更新，确保所有视图正确显示
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func updateButtonViews() {
        // 清空现有按钮
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 为每个按钮创建视图
        for (index, action) in alertActions.enumerated() {
            createButton(for: action, index: index)
        }
    }
    
    private func createButton(for action: ChimpionAlertAction, index: Int) {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tag = index
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 确保按钮标题不会被截断
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        // 设置按钮内容压缩阻力优先级，确保按钮根据标题长度合理分配空间
        button.titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        
        // 设置按钮样式
        if let style = buttonStyles[index] {
            button.titleLabel?.font = style.font
            button.setTitleColor(style.color, for: .normal)
        } else {
            // 默认样式
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            // 根据按钮类型设置默认颜色
            switch action.style {
            case ChimpionAlertAction.cancel:
                button.setTitleColor(.systemBlue, for: .normal)
            case ChimpionAlertAction.destructive:
                button.setTitleColor(.systemRed, for: .normal)
            default:
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
        
        // 在Sheet模式下设置按钮背景色和布局
        if preferredStyle == ChimpionAlertController.sheet {
            button.backgroundColor = .white
            
            // 为按钮创建容器视图，避免直接在stackView中混合按钮和分割线导致的布局问题
            let buttonContainer = UIView()
            buttonContainer.translatesAutoresizingMaskIntoConstraints = false
            buttonContainer.addSubview(button)
            
            // 按钮在容器中居中并填充水平空间 - 移除冗余的高度约束
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
                button.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            // 为每个按钮添加水平分割线（除了第一个）
            if index > 0 {
                let separatorView = UIView()
                separatorView.backgroundColor = .lightGray.withAlphaComponent(0.3)
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                buttonStackView.addArrangedSubview(separatorView)
                
                NSLayoutConstraint.activate([
                    separatorView.heightAnchor.constraint(equalToConstant: 1),
                    separatorView.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
                    separatorView.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor)
                ])
            }
            
            // 将按钮容器添加到栈视图
            buttonStackView.addArrangedSubview(buttonContainer)
            
            // 为容器视图设置高度约束
            buttonContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            // 为最后一个按钮添加底部内边距
            if index == alertActions.count - 1 {
                let bottomPadding = UIView()
                bottomPadding.translatesAutoresizingMaskIntoConstraints = false
                buttonStackView.addArrangedSubview(bottomPadding)
                bottomPadding.heightAnchor.constraint(equalToConstant: 16).isActive = true
            }
        } else {
            // 在Alert模式下设置按钮固定高度为50
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            // 在Alert模式下添加水平分割线
            if index > 0 {
                let separatorView = UIView()
                separatorView.backgroundColor = .lightGray.withAlphaComponent(0.3)
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                buttonStackView.addArrangedSubview(separatorView)
                
                NSLayoutConstraint.activate([
                    separatorView.widthAnchor.constraint(equalToConstant: 0.5),
                    separatorView.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor)
                ])
            }
            
            // 将按钮直接添加到栈视图
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - 事件处理
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        if index < alertActions.count {
            let action = alertActions[index]
            action.handler?(action)
        }
        
        hide(animated: true)
    }
    
    @objc private func backgroundTapped() {
        // Sheet模式下点击背景可以关闭
        if preferredStyle == ChimpionAlertController.sheet {
            hide(animated: true)
        }
        // Alert模式保持默认不关闭
    }
    
    // MARK: - 公共方法
    
    /// 添加按钮
    public func addAction(_ action: ChimpionAlertAction) {
        alertActions.append(action)
        
        // 如果视图已加载，更新UI
        if isViewLoaded {
            updateButtonViews()
        }
    }
    
    /// 设置标题的字体和颜色
    public func setTitleStyle(font: UIFont, color: UIColor) {
        self.titleFont = font
        self.titleColor = color
        
        // 更新标题标签样式
        titleLabel.font = font
        titleLabel.textColor = color
    }
    
    /// 设置消息的字体和颜色
    public func setMessageStyle(font: UIFont, color: UIColor) {
        self.messageFont = font
        self.messageColor = color
        
        // 更新消息标签样式
        messageLabel.font = font
        messageLabel.textColor = color
    }
    
    /// 设置按钮的字体和颜色
    public func setButtonStyle(atIndex index: Int, font: UIFont, color: UIColor) {
        buttonStyles[index] = (font: font, color: color)
        
        // 更新按钮样式
        if isViewLoaded {
            // 重新创建按钮视图以应用新样式
            updateButtonViews()
        }
    }
    
    /// 设置所有按钮的字体和颜色
    public func setAllButtonsStyle(font: UIFont, color: UIColor) {
        for index in 0..<alertActions.count {
            setButtonStyle(atIndex: index, font: font, color: color)
        }
    }
    
    // MARK: - 显示和隐藏方法
    
    /// 显示弹窗
    public func show(animated: Bool = true) {
        // 创建自定义窗口场景
        if #available(iOS 13.0, *) {
            // 获取当前活动的窗口场景
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                alertWindowScene = scene
                setupWindow(with: scene)
            } else {
                // 如果找不到活动场景，使用默认方法
                fallbackPresent()
            }
        } else {
            // iOS 13以下版本使用兼容方法
            fallbackPresent()
        }
    }
    
    /// 隐藏弹窗
    public func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0
                if self.preferredStyle == ChimpionAlertController.sheet {
                    // Sheet模式的关闭动画
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                } else {
                    // Alert模式的关闭动画
                    self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            }) { [weak self] _ in
                guard let self = self else { return }
                self.alertWindow?.isHidden = true
                self.alertWindow = nil
                self.alertWindowScene = nil
            }
        } else {
            alertWindow?.isHidden = true
            alertWindow = nil
            alertWindowScene = nil
        }
    }
    
    /// 设置自定义窗口
    private func setupWindow(with scene: UIWindowScene) {
        // 创建新窗口
        alertWindow = UIWindow(windowScene: scene)
        alertWindow?.windowLevel = .alert
        alertWindow?.backgroundColor = .clear
        alertWindow?.rootViewController = self
        
        // 显示窗口
        alertWindow?.makeKeyAndVisible()
        
        // 初始状态设置
        view.alpha = 0
        if preferredStyle == ChimpionAlertController.sheet {
            // Sheet模式的初始位置
            containerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        } else {
            // Alert模式的初始大小
            containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        // 动画显示
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 兼容模式下的显示方法（iOS 13以下或找不到窗口场景时使用）
    private func fallbackPresent() {
        // 获取当前最顶层的视图控制器
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topmostViewController() {
            modalPresentationStyle = .overCurrentContext
            modalTransitionStyle = .crossDissolve
            topViewController.present(self, animated: true, completion: nil)
        }
    }
    
    // MARK: - 重写dismiss方法以兼容旧的调用方式
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hide(animated: flag)
        completion?()
    }
}

// ChimpionAlertAction实现
public class ChimpionAlertAction {
    let title: String?
    let style: Int
    let handler: ((ChimpionAlertAction?) -> Void)?
    
    public init(title: String?, style: Int, handler: ((ChimpionAlertAction?) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension ChimpionAlertController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}

// ChimpionAlertAction样式常量
public extension ChimpionAlertAction {
    static var cancel: Int { 0 }
    static var `default`: Int { 1 }
    static var destructive: Int { 2 }
}



// MARK: - UIViewController扩展
public extension UIViewController {
    /// 获取最顶层的视图控制器
    func topmostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topmostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topmostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topmostViewController() ?? tab
        }
        
        return self
    }
}

//// MARK: - 数组安全扩展
//extension Array {
//    /// 安全访问数组元素，如果索引超出范围则返回nil
//    subscript(safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
