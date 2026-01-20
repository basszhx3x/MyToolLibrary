//
//  ViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 表格视图属性
    private let tableView = UITableView()
    
    // 定义测试项数据结构
    struct TestItem {
        let title: String
        let controllerType: ControllerType
        
        enum ControllerType {
            case customAlert
            case button
            case alert
            case grid
            case radioButton
            case segmentControl
            case attributedString
            case searchBar
            case routerManager
        }
    }
    
    // 测试项列表
    private let testItems: [TestItem] = [
        TestItem(title: "ChimpionCustomAlertController 测试", controllerType: .customAlert),
        TestItem(title: "ChimpionButton 测试", controllerType: .button),
        TestItem(title: "ChimpionAlertController 测试", controllerType: .alert),
        TestItem(title: "ChimpionGridView 测试", controllerType: .grid),
        TestItem(title: "ChimpionRadioButton 测试", controllerType: .radioButton),
        TestItem(title: "ChimpionSegmentControl 测试", controllerType: .segmentControl),
        TestItem(title: "NSAttributedString扩展 测试", controllerType: .attributedString),
        TestItem(title: "ChimpionSearchBarView 测试", controllerType: .searchBar),
        TestItem(title: "RouterManager 测试", controllerType: .routerManager)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "组件测试列表"
        
        // 设置导航栏背景色
        navigationController?.navigationBar.backgroundColor = .white
        
        // 设置视图背景色
        view.backgroundColor = .white
        
        // 配置表格视图
        setupTableView()
    }
    
    private func setupTableView() {
        // 设置tableView的dataSource和delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        
        // 设置样式
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        
        // 添加到视图并设置约束
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        let testItem = testItems[indexPath.row]
        
        // 配置单元格
        cell.textLabel?.text = testItem.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let testItem = testItems[indexPath.row]
        var viewController: UIViewController
        
        // 根据选择的测试项创建对应的视图控制器
        switch testItem.controllerType {
        case .customAlert:
            viewController = CustomAlertControllerTestViewController()
        case .button:
            viewController = ButtonControllerTestViewController()
        case .alert:
            viewController = AlertControllerTestViewController()
        case .grid:
            viewController = GridViewControllerTestViewController()
        case .radioButton:
            viewController = RadioButtonTestViewController()
        case .segmentControl:
            viewController = SegmentControlTestViewController()
        case .attributedString:
            viewController = AttributedStringTestViewController()
        case .searchBar:
            viewController = SearchBarControllerTestViewController()
        case .routerManager:
            viewController = RouterManagerTestViewController()
        }
        
        // 设置标题并推送
        viewController.title = testItem.title
        navigationController?.pushViewController(viewController, animated: true)
        
        print("跳转到: \(testItem.title)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// 导入测试视图控制器文件已单独创建，此处不包含内联定义

