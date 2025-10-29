//
//  GridViewControllerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

// ChimpionGridView 测试视图控制器
class GridViewControllerTestViewController: UIViewController, ChimpionGridViewDataSource, ChimpionGridViewDelegate {
    
    private var gridView: ChimpionGridView?
    private var testItems: [String] = []
    private let cellIdentifier = "TestCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色
        view.backgroundColor = .white
        
        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "ChimpionGridView 测试"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 准备测试数据
        prepareTestData()
        
        // 创建ChimpionGridView
        setupGridView()
        
        // 设置标题约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func prepareTestData() {
        // 生成测试数据
        for i in 1...24 {
            testItems.append("项目 \(i)")
        }
    }
    
    private func setupGridView() {
        // 创建网格视图并添加到主视图
        gridView = ChimpionGridView()
        guard let gridView = gridView else { return }
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)
        
        // 设置网格视图约束
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        // 配置网格视图属性
        gridView.dataSource = self
        gridView.delegate = self
        gridView.numberOfColumns = 3
        gridView.minimumInteritemSpacing = 12
        gridView.minimumLineSpacing = 12
        gridView.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // 注册单元格
        gridView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        print("ChimpionGridView 初始化完成并配置了数据源和代理")
    }
    
    // MARK: - ChimpionGridViewDataSource
    
    func numberOfItems(in gridView: ChimpionGridView) -> Int {
        return testItems.count
    }
    
    func gridView(_ gridView: ChimpionGridView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // 清除现有子视图
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // 设置单元格背景色和圆角
        let colors: [UIColor] = [
            UIColor.red.withAlphaComponent(0.2),
            UIColor.blue.withAlphaComponent(0.2),
            UIColor.green.withAlphaComponent(0.2),
            UIColor.yellow.withAlphaComponent(0.2),
            UIColor.purple.withAlphaComponent(0.2),
            UIColor.orange.withAlphaComponent(0.2)
        ]
        
        cell.contentView.backgroundColor = colors[indexPath.item % colors.count]
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        // 创建文本标签
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = testItems[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        
        // 添加标签到单元格
        cell.contentView.addSubview(label)
        
        // 设置标签约束
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8)
        ])
        
        return cell
    }
    
    // MARK: - ChimpionGridViewDelegate
    
    func gridView(_ gridView: ChimpionGridView, didSelectItemAt indexPath: IndexPath) {
        print("选中了项目: \(testItems[indexPath.item])")
        
        // 显示选中的项目信息
        let alert = UIAlertController(title: "选中项目", message: testItems[indexPath.item], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    func gridView(_ gridView: ChimpionGridView, collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 根据列数和间距计算单元格宽度
        let totalWidth = gridView.bounds.width - gridView.sectionInset.left - gridView.sectionInset.right
        let spacing = CGFloat(gridView.numberOfColumns - 1) * gridView.minimumInteritemSpacing
        let itemWidth = (totalWidth - spacing) / CGFloat(gridView.numberOfColumns)
        
        // 返回单元格尺寸（宽高比 1:1.2）
        return CGSize(width: itemWidth, height: itemWidth * 1.2)
    }
}
