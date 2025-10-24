import UIKit

// MARK: - 数据源协议
/// GridView数据源协议
public protocol ChimpionGridViewDataSource: AnyObject {
    /// 获取网格视图中的项目数量
    /// - Parameter gridView: 调用此方法的网格视图
    /// - Returns: 项目总数
    func numberOfItems(in gridView: ChimpionGridView) -> Int
    
    /// 获取指定索引位置的单元格
    /// - Parameters:
    ///   - gridView: 调用此方法的网格视图
    ///   - indexPath: 单元格的索引路径
    /// - Returns: 配置好的单元格
    func gridView(_ gridView: ChimpionGridView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

// MARK: - 代理协议
/// GridView代理协议
public protocol ChimpionGridViewDelegate: AnyObject {
    /// 当某个项目被点击时调用
    /// - Parameters:
    ///   - gridView: 调用此方法的网格视图
    ///   - indexPath: 被点击项目的索引路径
    func gridView(_ gridView: ChimpionGridView, didSelectItemAt indexPath: IndexPath)
    
    /// 自定义单元格尺寸
    /// - Parameters:
    ///   - gridView: 调用此方法的网格视图
    ///   - collectionView: 内部的集合视图
    ///   - indexPath: 单元格的索引路径
    /// - Returns: 单元格的尺寸
    func gridView(_ gridView: ChimpionGridView, collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

// MARK: - GridView组件
/// 网格视图组件，基于UICollectionView实现
public class ChimpionGridView: UIView, UICollectionViewDelegateFlowLayout {
    // MARK: - 属性
    
    /// 内部集合视图
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = selfDataSource
        view.backgroundColor = .clear
        return view
    }()
    
    /// 数据源
    public weak var dataSource: ChimpionGridViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    /// 代理
    public weak var delegate: ChimpionGridViewDelegate?
    
    /// 列数
    public var numberOfColumns: Int = 2 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 水平间距
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = minimumInteritemSpacing
                collectionView.reloadData()
            }
        }
    }
    
    /// 垂直间距
    public var minimumLineSpacing: CGFloat = 10 {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = minimumLineSpacing
                collectionView.reloadData()
            }
        }
    }
    
    /// 内边距
    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = sectionInset
                collectionView.reloadData()
            }
        }
    }
    
    /// 是否允许滚动
    public var isScrollEnabled: Bool {
        get { collectionView.isScrollEnabled }
        set { collectionView.isScrollEnabled = newValue }
    }
    
    /// 内部数据源代理，转发到外部数据源
    private let selfDataSource = SelfDataSource()
    
    // MARK: - 生命周期
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - 初始化方法
    
    private func setupViews() {
        // 设置内部数据源的引用
        selfDataSource.gridView = self
        
        // 添加集合视图
        addSubview(collectionView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - 公共方法
    
    /// 注册单元格类型
    /// - Parameters:
    ///   - cellClass: 单元格类类型
    ///   - identifier: 重用标识符
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    /// 注册单元格Nib文件
    /// - Parameters:
    ///   - nib: 单元格Nib对象
    ///   - identifier: 重用标识符
    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// 重新加载数据
    public func reloadData() {
        collectionView.reloadData()
    }
    
    /// 获取可见单元格的索引路径数组
    public var indexPathsForVisibleItems: [IndexPath] {
        return collectionView.indexPathsForVisibleItems
    }
    
    /// 滚动到指定索引路径的位置
    /// - Parameters:
    ///   - indexPath: 目标索引路径
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否使用动画
    public func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 如果代理提供了自定义尺寸，则使用代理的实现
        if let size = delegate?.gridView(self, collectionView: collectionView, sizeForItemAt: indexPath) {
            return size
        }
        
        // 否则根据列数自动计算尺寸
        let totalWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let spacing = CGFloat(numberOfColumns - 1) * minimumInteritemSpacing
        let itemWidth = (totalWidth - spacing) / CGFloat(numberOfColumns)
        
        return CGSize(width: itemWidth, height: itemWidth) // 默认正方形
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.gridView(self, didSelectItemAt: indexPath)
    }
}

// MARK: - 内部数据源实现
/// 内部数据源类，用于转发数据源方法调用
private class SelfDataSource: NSObject, UICollectionViewDataSource {
    /// 引用外部GridView
    weak var gridView: ChimpionGridView?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridView?.dataSource?.numberOfItems(in: gridView!) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let gridView = gridView, let dataSource = gridView.dataSource else {
            fatalError("ChimpionGridView: dataSource is not set")
        }
        return dataSource.gridView(gridView, cellForItemAt: indexPath)
    }
}

// MARK: - 使用示例
/*
使用示例：

class GridViewExampleViewController: UIViewController, ChimpionGridViewDataSource, ChimpionGridViewDelegate {
    
    private let gridView = ChimpionGridView()
    private let dataItems = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置GridView
        setupGridView()
    }
    
    private func setupGridView() {
        // 配置GridView属性
        gridView.frame = view.bounds
        gridView.dataSource = self
        gridView.delegate = self
        gridView.numberOfColumns = 3
        gridView.minimumInteritemSpacing = 15
        gridView.minimumLineSpacing = 15
        gridView.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        // 注册自定义单元格（如果有）
        gridView.register(MyCustomCell.self, forCellWithReuseIdentifier: "MyCustomCell")
        
        view.addSubview(gridView)
    }
    
    // MARK: - ChimpionGridViewDataSource
    
    func numberOfItems(in gridView: ChimpionGridView) -> Int {
        return dataItems.count
    }
    
    func gridView(_ gridView: ChimpionGridView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCell", for: indexPath)
        
        // 配置单元格内容
        if let customCell = cell as? MyCustomCell {
            customCell.textLabel.text = dataItems[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - ChimpionGridViewDelegate
    
    func gridView(_ gridView: ChimpionGridView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index: \(indexPath.item)")
    }
    
    func gridView(_ gridView: ChimpionGridView, collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 自定义单元格尺寸
        return CGSize(width: 100, height: 100)
    }
}

// 自定义单元格示例
class MyCustomCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
