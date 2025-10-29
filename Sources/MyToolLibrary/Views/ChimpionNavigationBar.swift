import UIKit

/// 自定义导航栏组件，模仿iOS原生NavigationBar的外观和行为
/// 支持左侧按钮、中间标题和右侧按钮的灵活配置
public class ChimpionNavigationBar: UIView {
    
    // MARK: - UI Components
    
    /// 左侧容器视图，用于放置左侧按钮
    private let leftContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .left
        return view
    }()
    
    /// 中间标题容器视图，用于放置标题标签
    private let centerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        view.clipsToBounds = true
        return view
    }()
    
    /// 右侧容器视图，用于放置右侧按钮
    private let rightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .right
        return view
    }()
    
    /// 标题标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    /// 底部分隔线
    private let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return view
    }()
    
    // MARK: - Public Properties
    
    /// 导航栏标题
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// 标题字体
    public var titleFont: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    /// 标题颜色
    public var titleColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    
    /// 导航栏背景色
    public var barBackgroundColor: UIColor {
        get { backgroundColor ?? .white }
        set { backgroundColor = newValue }
    }
    
    /// 是否显示底部分隔线
    public var showsBottomBorder: Bool = true {
        didSet {
            bottomBorder.isHidden = !showsBottomBorder
        }
    }
    
    /// 底部分隔线颜色
    public var bottomBorderColor: UIColor {
        get { bottomBorder.backgroundColor ?? .systemGray.withAlphaComponent(0.3) }
        set { bottomBorder.backgroundColor = newValue }
    }
    
    /// 左侧按钮与边缘的间距
    public var leftContentInset: CGFloat = 16 {
        didSet {
            updateLeftContentInset()
        }
    }
    
    /// 右侧按钮与边缘的间距
    public var rightContentInset: CGFloat = 16 {
        didSet {
            updateRightContentInset()
        }
    }
    
    /// 标题左右边距的最大限制，用于防止标题与两侧按钮重叠
    public var titleMaxWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    /// 初始化方法
    /// - Parameters:
    ///   - frame: 视图框架
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /// 从xib/storyboard初始化
    /// - Parameter coder: 解码器
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Methods
    
    /// 设置视图层次结构和约束
    private func setupViews() {
        backgroundColor = .white
        
        // 添加子视图
        addSubview(leftContainer)
        addSubview(centerContainer)
        addSubview(rightContainer)
        addSubview(bottomBorder)
        
        centerContainer.addSubview(titleLabel)
        
        // 设置约束
        setupConstraints()
    }
    
    /// 设置自动布局约束
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 高度默认设置为44，这是iOS导航栏的标准高度
            heightAnchor.constraint(equalToConstant: 44),
            
            // 左侧容器约束
            leftContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            // 右侧容器约束
            rightContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            // 中间容器约束
            centerContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leftContainer.trailingAnchor, constant: 8),
            centerContainer.trailingAnchor.constraint(lessThanOrEqualTo: rightContainer.leadingAnchor, constant: -8),
            centerContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            // 标题标签约束
            titleLabel.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerContainer.centerYAnchor),
            
            // 底部分隔线约束
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        // 设置标题最大宽度约束，防止标题过长
        titleMaxWidthConstraint = centerContainer.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.5)
        titleMaxWidthConstraint?.isActive = true
        
        // 更新内容边距
        updateLeftContentInset()
        updateRightContentInset()
    }
    
    // MARK: - Public Methods
    
    /// 设置左侧按钮
    /// - Parameters:
    ///   - button: 要设置的按钮
    ///   - target: 目标对象
    ///   - action: 点击事件
    public func setLeftButton(_ button: UIButton, target: Any?, action: Selector?) {
        // 清除左侧容器中的现有按钮
        leftContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // 设置按钮
        button.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(button)
        
        // 添加约束 - 使用layoutMarginsGuide来应用边距
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leftContainer.layoutMarginsGuide.leadingAnchor),
            button.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            button.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 添加点击事件
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    /// 创建并设置标准返回按钮
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 返回事件
    /// - Returns: 创建的返回按钮
    @discardableResult
    public func setBackButton(target: Any?, action: Selector?) -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        // 尝试设置返回图标（iOS风格的左箭头）
        if let backImage = UIImage(systemName: "chevron.backward") {
            backButton.setImage(backImage, for: .normal)
            backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
        
        setLeftButton(backButton, target: target, action: action)
        return backButton
    }
    
    /// 设置右侧按钮
    /// - Parameters:
    ///   - button: 要设置的按钮
    ///   - target: 目标对象
    ///   - action: 点击事件
    public func setRightButton(_ button: UIButton, target: Any?, action: Selector?) {
        // 清除右侧容器中的现有按钮
        rightContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // 设置按钮
        button.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.addSubview(button)
        
        // 添加约束 - 使用layoutMarginsGuide来应用边距
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: rightContainer.layoutMarginsGuide.trailingAnchor),
            button.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            button.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 添加点击事件
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    /// 设置右侧按钮（多个）
    /// - Parameters:
    ///   - buttons: 按钮数组
    ///   - target: 目标对象
    ///   - action: 点击事件（所有按钮共享同一个事件，通过tag区分）
    public func setRightButtons(_ buttons: [UIButton], target: Any?, action: Selector?) {
        // 清除右侧容器中的现有按钮
        rightContainer.subviews.forEach { $0.removeFromSuperview() }
        
        var previousButton: UIButton?
        
        // 添加按钮并设置约束
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            rightContainer.addSubview(button)
            button.tag = index
            
            var constraints = [
                button.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor),
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
                button.heightAnchor.constraint(equalToConstant: 44)
            ]
            
            if let previousButton = previousButton {
                constraints.append(button.trailingAnchor.constraint(equalTo: previousButton.leadingAnchor, constant: -8))
            } else {
                // 使用layoutMarginsGuide来应用边距
                constraints.append(button.trailingAnchor.constraint(equalTo: rightContainer.layoutMarginsGuide.trailingAnchor))
            }
            
            NSLayoutConstraint.activate(constraints)
            
            // 添加点击事件
            if let action = action {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
            
            previousButton = button
        }
    }
    
    /// 设置标题视图（自定义视图替代标题标签）
    /// - Parameter customView: 自定义视图
    public func setTitleView(_ customView: UIView) {
        // 清除现有标题标签
        centerContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // 添加自定义视图
        customView.translatesAutoresizingMaskIntoConstraints = false
        centerContainer.addSubview(customView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor),
            customView.topAnchor.constraint(equalTo: centerContainer.topAnchor),
            customView.bottomAnchor.constraint(equalTo: centerContainer.bottomAnchor)
        ])
    }
    
    /// 重置导航栏到默认状态
    public func reset() {
        title = nil
        
        // 清除所有容器中的子视图
        leftContainer.subviews.forEach { $0.removeFromSuperview() }
        rightContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // 重新添加标题标签
        centerContainer.subviews.forEach { $0.removeFromSuperview() }
        centerContainer.addSubview(titleLabel)
        
        // 重新设置标题标签约束
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerContainer.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    /// 更新左侧内容边距
    private func updateLeftContentInset() {
        // 直接更新布局边距，按钮约束已经使用了layoutMarginsGuide
        leftContainer.layoutMargins = UIEdgeInsets(top: 0, left: leftContentInset, bottom: 0, right: 0)
        
        // 强制布局更新
        leftContainer.setNeedsLayout()
    }
    
    /// 更新右侧内容边距
    private func updateRightContentInset() {
        // 直接更新布局边距，按钮约束已经使用了layoutMarginsGuide
        rightContainer.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightContentInset)
        
        // 强制布局更新
        rightContainer.setNeedsLayout()
    }
    
    // MARK: - Layout
    
    /// 布局子视图
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新内容边距
        updateLeftContentInset()
        updateRightContentInset()
    }
    
    /// 计算固有内容尺寸
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
}
