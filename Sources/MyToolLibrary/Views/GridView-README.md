# ChimpionGridView 使用指南

## 简介

`ChimpionGridView` 是一个基于 `UICollectionView` 的灵活网格视图组件，支持根据数据源平铺显示数据。它提供了简洁的 API 来配置网格布局、单元格大小和间距等属性，同时保持了与 UICollectionView 类似的数据源和代理设计模式。

## 特性

- 支持自定义列数
- 可配置的水平和垂直间距
- 自定义内边距
- 自定义单元格大小
- 支持点击事件回调
- 与 UICollectionView 兼容的注册机制
- 支持滚动控制

## 快速开始

### 1. 导入组件

```swift
import MyToolLibrary
```

### 2. 创建 GridView

```swift
let gridView = ChimpionGridView()
gridView.frame = view.bounds
view.addSubview(gridView)
```

### 3. 设置数据源和代理

```swift
gridView.dataSource = self
gridView.delegate = self
```

### 4. 实现必要的协议方法

```swift
// MARK: - ChimpionGridViewDataSource

func numberOfItems(in gridView: ChimpionGridView) -> Int {
    return items.count
}

func gridView(_ gridView: ChimpionGridView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = gridView.collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
    // 配置单元格...
    return cell
}

// MARK: - ChimpionGridViewDelegate

func gridView(_ gridView: ChimpionGridView, didSelectItemAt indexPath: IndexPath) {
    // 处理点击事件...
}
```

## 配置选项

### 基本配置

```swift
// 设置列数
gridView.numberOfColumns = 3

// 设置间距
gridView.minimumInteritemSpacing = 10 // 水平间距
gridView.minimumLineSpacing = 10      // 垂直间距

// 设置内边距
gridView.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

// 控制滚动
gridView.isScrollEnabled = true
```

### 自定义单元格大小

实现代理方法来提供自定义的单元格尺寸：

```swift
func gridView(_ gridView: ChimpionGridView, collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // 根据不同的索引返回不同的尺寸
    if indexPath.item % 2 == 0 {
        return CGSize(width: 100, height: 100)
    } else {
        return CGSize(width: 150, height: 150)
    }
}
```

## 单元格注册

### 注册类

```swift
gridView.register(MyCustomCell.self, forCellWithReuseIdentifier: "MyCustomCell")
```

### 注册 Nib

```swift
let nib = UINib(nibName: "MyCustomCell", bundle: nil)
gridView.register(nib, forCellWithReuseIdentifier: "MyCustomCell")
```

## 常用方法

```swift
// 重新加载数据
gridView.reloadData()

// 获取可见单元格的索引路径
let visibleIndexPaths = gridView.indexPathsForVisibleItems

// 滚动到指定位置
gridView.scrollToItem(at: IndexPath(item: 0, section: 0), 
                     at: .top,
                     animated: true)
```

## 完整示例

```swift
class GridViewController: UIViewController, ChimpionGridViewDataSource, ChimpionGridViewDelegate {
    
    private let gridView = ChimpionGridView()
    private var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置 GridView
        setupGridView()
    }
    
    private func setupGridView() {
        // 设置布局
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridView.rightAnchor.constraint(equalTo: view.rightAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 设置数据源和代理
        gridView.dataSource = self
        gridView.delegate = self
        
        // 配置外观
        gridView.numberOfColumns = 2
        gridView.minimumInteritemSpacing = 16
        gridView.minimumLineSpacing = 16
        gridView.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // 注册单元格
        gridView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    // MARK: - ChimpionGridViewDataSource
    
    func numberOfItems(in gridView: ChimpionGridView) -> Int {
        return items.count
    }
    
    func gridView(_ gridView: ChimpionGridView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // 重置单元格
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // 创建并配置标签
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = items[indexPath.item]
        label.textAlignment = .center
        label.textColor = .black
        
        // 设置单元格背景
        cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell.contentView.layer.cornerRadius = 8
        
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
        print("Selected item: \(items[indexPath.item])")
    }
    
    func gridView(_ gridView: ChimpionGridView, collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 计算单元格宽度（考虑内边距和间距）
        let totalWidth = view.bounds.width - gridView.sectionInset.left - gridView.sectionInset.right
        let spacing = CGFloat(gridView.numberOfColumns - 1) * gridView.minimumInteritemSpacing
        let itemWidth = (totalWidth - spacing) / CGFloat(gridView.numberOfColumns)
        
        return CGSize(width: itemWidth, height: itemWidth * 0.8) // 宽高比 5:4
    }
}
```

## 注意事项

1. 确保为单元格注册正确的重用标识符
2. 在实现 `cellForItemAt` 方法时，记得从重用池中正确地获取和配置单元格
3. 如果需要自定义单元格大小，实现 `sizeForItemAt` 代理方法
4. 对于复杂的单元格，建议创建自定义的 `UICollectionViewCell` 子类

## 性能优化

- 对于大量数据，考虑实现 `UICollectionViewDataSourcePrefetching` 协议进行预加载
- 自定义单元格时，尽量重用视图组件而不是每次都创建新的
- 避免在 `cellForItemAt` 方法中执行耗时操作