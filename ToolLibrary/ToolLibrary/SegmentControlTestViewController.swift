//
//  SegmentControlTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

class SegmentControlTestViewController: UIViewController {

    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI 设置
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "分段控制器测试"
        
        // 创建默认样式的分段控制器
        let defaultSegmentControl = createDefaultSegmentControl()
        
        // 创建自定义样式的分段控制器
        let customSegmentControl = createCustomSegmentControl()
        
        // 创建使用fitToText样式的分段控制器
        let fitToTextSegmentControl = createFitToTextSegmentControl()
        
        // 创建带分割线的分段控制器
        let dividerSegmentControl = createDividerSegmentControl()
        
        // 使用堆栈视图排列分段控制器
        let stackView = UIStackView(arrangedSubviews: [defaultSegmentControl, customSegmentControl, fitToTextSegmentControl, dividerSegmentControl])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // 添加标签显示当前选中的选项
        let statusLabel = UILabel()
        statusLabel.text = "选中状态将在这里显示"
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // 设置选中回调
        defaultSegmentControl.selectionCallback = { index in
            statusLabel.text = "默认样式：选中了选项 \(index + 1): \(defaultSegmentControl.titles[index])"
        }
        
        customSegmentControl.selectionCallback = { index in
            statusLabel.text = "自定义样式：选中了选项 \(index + 1): \(customSegmentControl.titles[index])"
        }
        
        fitToTextSegmentControl.selectionCallback = { index in
            statusLabel.text = "FitToText样式：选中了选项 \(index + 1): \(fitToTextSegmentControl.titles[index])"
        }
        
        dividerSegmentControl.selectionCallback = { index in
            statusLabel.text = "带分割线样式：选中了选项 \(index + 1): \(dividerSegmentControl.titles[index])"
        }
    }
    
    // MARK: - 创建不同样式的分段控制器
    
    private func createDefaultSegmentControl() -> ChimpionSegmentControl {
        let segmentControl = ChimpionSegmentControl(
            titles: ["选项一", "选项二", "选项三"]
        )
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.layer.cornerRadius = 8
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = UIColor.systemGray3.cgColor
        
        return segmentControl
    }
    
    private func createCustomSegmentControl() -> ChimpionSegmentControl {
        let customConfig = SegmentConfig(
            selectedTextColor: .white,
            unselectedTextColor: .darkGray,
            selectedBackgroundColor: .systemPurple,
            unselectedBackgroundColor: .systemGray,
            font: .systemFont(ofSize: 17, weight: .semibold),
            indicatorColor: .systemYellow,
            indicatorHeight: 4,
            itemSpacing: 5,
            contentInsets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        )
        
        let segmentControl = ChimpionSegmentControl(
            config: customConfig,
            titles: ["红色", "绿色", "蓝色", "黄色"]
        )
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.layer.cornerRadius = 12
        segmentControl.clipsToBounds = true
        
        return segmentControl
    }
    
    private func createFitToTextSegmentControl() -> ChimpionSegmentControl {
        let fitToTextConfig = SegmentConfig(
            indicatorStyle: .fitToText,
            indicatorColor: .systemOrange,
            indicatorHeight: 3,
            contentInsets: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        )
        
        let segmentControl = ChimpionSegmentControl(
            config: fitToTextConfig,
            titles: ["短", "中等长度", "非常长的选项"]
        )
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .systemGray5
        segmentControl.layer.cornerRadius = 20
        
        return segmentControl
    }
    
    private func createDividerSegmentControl() -> ChimpionSegmentControl {
        let dividerConfig = SegmentConfig(
            selectedTextColor: .systemGreen,
            unselectedTextColor: .systemGray5,
            selectedBackgroundColor: .systemGreen.withAlphaComponent(0.1),
            unselectedBackgroundColor: .systemGray,
            font: .systemFont(ofSize: 16, weight: .medium),
            indicatorStyle: .fullWidth,
            indicatorColor: .systemGreen,
            indicatorHeight: 3,
            contentInsets: UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10),
            showDivider: true,              // 启用分割线
            dividerColor: .systemGray3,     // 设置分割线颜色
            dividerWidth: 1,                // 设置分割线宽度
            dividerHeightRatio: 0.6         // 设置分割线高度占按钮高度的60%
        )
        
        let segmentControl = ChimpionSegmentControl(
            config: dividerConfig,
            titles: ["周一", "周二", "周三", "周四", "周五"]
        )
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.layer.cornerRadius = 8
        segmentControl.clipsToBounds = true
        
        return segmentControl
    }
}
