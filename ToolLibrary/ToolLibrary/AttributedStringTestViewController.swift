//
//  AttributedStringTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2024/10/12.
//

import UIKit
import ChimpionTools

/// NSAttributedString扩展测试视图控制器
class AttributedStringTestViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTestCases()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "NSAttributedString扩展测试"
        
        // 配置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)
        
        // 配置内容堆栈视图
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .leading
        contentStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(contentStackView)
        
        // 配置状态标签
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .systemGray
        statusLabel.numberOfLines = 0
        statusLabel.text = "点击下方按钮查看NSAttributedString扩展效果"
        contentStackView.addArrangedSubview(statusLabel)
        
        // 添加约束
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // 内容堆栈视图约束
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTestCases() {
        // 测试1: 基本构造方法
        createTestCaseButton(title: "测试1: 基本构造方法") { [weak self] in
            self?.testBasicInitialization()
        }
        
        // 测试2: 链式调用
        createTestCaseButton(title: "测试2: 链式调用") { [weak self] in
            self?.testChainingMethods()
        }
        
        // 测试3: 文本样式设置
        createTestCaseButton(title: "测试3: 文本样式设置") { [weak self] in
            self?.testTextStyling()
        }
        
        // 测试4: 文本组合
        createTestCaseButton(title: "测试4: 文本组合") { [weak self] in
            self?.testTextCombination()
        }
        
        // 测试5: 文本高亮
        createTestCaseButton(title: "测试5: 文本高亮") { [weak self] in
            self?.testTextHighlighting()
        }
    }
    
    private func createTestCaseButton(title: String, action: @escaping () -> Void) {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .leading
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = title
        
        // 关联操作
        objc_setAssociatedObject(button, &TestButtonKey.action, action, .OBJC_ASSOCIATION_RETAIN)
        
        contentStackView.addArrangedSubview(button)
        
        // 设置按钮宽度约束
        button.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: -40).isActive = true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let action = objc_getAssociatedObject(sender, &TestButtonKey.action) as? () -> Void {
            action()
        }
    }
    
    // MARK: - 测试方法
    
    private func testBasicInitialization() {
        // 测试基本构造方法
        let label = createResultLabel()
        
        // 使用不同构造方法创建富文本
        let attr1 = NSAttributedString(string: "基本颜色和字体测试", color: .systemBlue, font: .systemFont(ofSize: 18, weight: .bold))
        let attr2 = NSAttributedString(string: "仅设置字体测试", font: .systemFont(ofSize: 16, weight: .medium))
        let attr3 = NSAttributedString(string: "使用文本样式测试", style: .headline)
        
        // 组合显示
        let combined = NSMutableAttributedString()
        combined.append(attr1)
        combined.append(NSAttributedString(string: "\n"))
        combined.append(attr2)
        combined.append(NSAttributedString(string: "\n"))
        combined.append(attr3)
        
        label.attributedText = combined
        updateStatusLabel(text: "测试了基本构造方法：颜色+字体、仅字体、文本样式")
    }
    
    private func testChainingMethods() {
        // 测试链式调用
        let label = createResultLabel()
        
        // 使用链式调用设置多个属性
        let attributedString = NSAttributedString(string: "链式调用测试")
            .color(.systemRed)
            .font(.systemFont(ofSize: 20, weight: .semibold))
            .underline(style: .double, color: .systemGreen)
            .kern(2.0)
            .alignment(.center)
        
        label.attributedText = attributedString
        label.textAlignment = .center
        updateStatusLabel(text: "测试了链式调用：颜色、字体、双下划线、字间距、居中对齐")
    }
    
    private func testTextStyling() {
        // 测试文本样式设置
        let label = createResultLabel()
        label.numberOfLines = 0
        
        // 测试各种文本样式
        let text = "这是一个样式测试文本\n包含多种不同的样式\n用于展示富文本的各种效果"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
        
        let mutableAttr = NSMutableAttributedString(string: text, attributes: attributes)
        
        // 设置部分文本样式
        mutableAttr.addColor(.systemPurple, range: NSRange(location: 0, length: 7))
        mutableAttr.addFont(.boldSystemFont(ofSize: 18), range: NSRange(location: 0, length: 7))
        mutableAttr.addColor(.systemOrange, range: NSRange(location: 8, length: 8))
        mutableAttr.addFont(.italicSystemFont(ofSize: 16), range: NSRange(location: 8, length: 8))
        mutableAttr.addColor(.systemBlue, range: NSRange(location: 17, length: 9))
        
        label.attributedText = mutableAttr
        updateStatusLabel(text: "测试了多种文本样式：不同颜色、字体粗细、斜体，以及段落样式")
    }
    
    private func testTextCombination() {
        // 测试文本组合
        let label = createResultLabel()
        label.numberOfLines = 0
        
        // 创建多个富文本并组合
        let part1 = NSAttributedString(string: "第一部分文本 ", color: .systemBlue, font: .systemFont(ofSize: 18))
        let part2 = NSAttributedString(string: "(带下划线)", color: .systemRed, font: .systemFont(ofSize: 16)).addingUnderline()
        let part3 = NSAttributedString(string: "\n第二部分文本 ", color: .systemGreen, font: .systemFont(ofSize: 18))
        let part4 = NSAttributedString(string: "(带中划线)", color: .systemPurple, font: .systemFont(ofSize: 16)).addingStrikethrough()
        
        // 使用appending方法组合
        let combined = part1.appending(part2).appending(part3).appending(part4)
        
        label.attributedText = combined
        updateStatusLabel(text: "测试了文本组合功能：使用appending方法连接多个不同样式的富文本")
    }
    
    private func testTextHighlighting() {
        // 测试文本高亮
        let label = createResultLabel()
        label.numberOfLines = 0
        
        let text = "这是一个高亮测试文本，用于演示如何高亮特定的关键词。" +
                   "高亮功能可以帮助用户快速找到重要信息。" +
                   "多个相同的关键词也可以被全部高亮，如测试、测试、测试。"
        
        let mutableAttr = NSMutableAttributedString(string: text, font: .systemFont(ofSize: 16))
        
        // 高亮单个关键词
        mutableAttr.highlight(text: "高亮", withColor: .yellow)
        
        // 高亮所有相同关键词
        mutableAttr.highlightAll(occurrencesOf: "测试", withColor: .green)
        
        label.attributedText = mutableAttr
        updateStatusLabel(text: "测试了文本高亮功能：单个关键词高亮和多个相同关键词全部高亮")
    }
    
    private func createResultLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // 移除之前的结果标签
        for subview in contentStackView.arrangedSubviews where subview is UILabel && subview != statusLabel {
            contentStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        contentStackView.addArrangedSubview(label)
        label.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: -40).isActive = true
        
        return label
    }
    
    private func updateStatusLabel(text: String) {
        statusLabel.text = text
        
        // 滚动到顶部
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.scrollToTop(animated: true)
        }
    }
}

// 用于关联按钮和操作的键
private struct TestButtonKey {
    static var action = "testButtonAction"
}

// 为UILabel添加内边距扩展
private extension UILabel {
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        set {
            layer.sublayerTransform = CATransform3DMakeTranslation(newValue.left, newValue.top, 0)
        }
    }
}

// 为UIScrollView添加滚动到顶部扩展
private extension UIScrollView {
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }
}
