//
//  ButtonControllerTestViewController.swift
//  ToolLibrary
//
//  Created by basszhx3x on 2025/10/10.
//

import UIKit
import ChimpionTools

// ChimpionButton 测试视图控制器
class ButtonControllerTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色
        view.backgroundColor = .white
        
        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "ChimpionButton 测试"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 创建测试按钮
        createTestButtons()
        
        // 设置标题约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // 创建测试按钮
    private func createTestButtons() {
        // 顶部图标按钮
        let topIconButton = ChimpionButton()
        topIconButton.setTitle("顶部图标"+"顶部图标", for: .normal)
        topIconButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        topIconButton.translatesAutoresizingMaskIntoConstraints = false
        topIconButton.setTitleColor(.black, for: .normal)
        topIconButton.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        topIconButton.layer.cornerRadius = 12
        topIconButton.imagePosition = .top // 设置图标在顶部
        topIconButton.spacing = 8 // 设置图标与文字间距
        topIconButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // 左侧图标按钮
        let leftIconButton = ChimpionButton()
        leftIconButton.setTitle("左侧图标", for: .normal)
        leftIconButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        leftIconButton.translatesAutoresizingMaskIntoConstraints = false
        leftIconButton.setTitleColor(.black, for: .normal)
        leftIconButton.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        leftIconButton.layer.cornerRadius = 12
        leftIconButton.imagePosition = .left // 设置图标在左侧（默认值）
        leftIconButton.spacing = 8 // 设置图标与文字间距
        leftIconButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // 右侧图标按钮
        let rightIconButton = ChimpionButton()
        rightIconButton.setTitle("右侧图标", for: .normal)
        rightIconButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        rightIconButton.translatesAutoresizingMaskIntoConstraints = false
        rightIconButton.setTitleColor(.black, for: .normal)
        rightIconButton.backgroundColor = .systemOrange.withAlphaComponent(0.2)
        rightIconButton.layer.cornerRadius = 12
        rightIconButton.imagePosition = .right // 设置图标在右侧
        rightIconButton.spacing = 8 // 设置图标与文字间距
        rightIconButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // 底部图标按钮
        let bottomIconButton = ChimpionButton()
        bottomIconButton.setTitle("底部图标", for: .normal)
        bottomIconButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        bottomIconButton.translatesAutoresizingMaskIntoConstraints = false
        bottomIconButton.setTitleColor(.black, for: .normal)
        bottomIconButton.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        bottomIconButton.layer.cornerRadius = 12
        bottomIconButton.imagePosition = .bottom // 设置图标在底部
        bottomIconButton.spacing = 8 // 设置图标与文字间距
        bottomIconButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // 创建栈视图来排列按钮
        let stackView = UIStackView(arrangedSubviews: [topIconButton, leftIconButton, rightIconButton, bottomIconButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 设置按钮尺寸
        NSLayoutConstraint.activate([
            topIconButton.widthAnchor.constraint(equalToConstant: 150),
            topIconButton.heightAnchor.constraint(equalToConstant: 100),
            
            leftIconButton.widthAnchor.constraint(equalToConstant: 150),
            leftIconButton.heightAnchor.constraint(equalToConstant: 50),
            
            rightIconButton.widthAnchor.constraint(equalToConstant: 150),
            rightIconButton.heightAnchor.constraint(equalToConstant: 50),
            
            bottomIconButton.widthAnchor.constraint(equalToConstant: 150),
            bottomIconButton.heightAnchor.constraint(equalToConstant: 100),
            
            // 设置栈视图约束
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // 创建选中状态测试按钮
        createSelectedStateTestButtons()
    }
    
    // 创建选中状态测试按钮
    private func createSelectedStateTestButtons() {
        // 选中背景色测试按钮
        let selectedBgButton = ChimpionButton()
        selectedBgButton.setTitle("选中背景色", for: .normal)
        selectedBgButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        selectedBgButton.translatesAutoresizingMaskIntoConstraints = false
        selectedBgButton.setTitleColor(.black, for: .normal)
        selectedBgButton.backgroundColor = .systemRed.withAlphaComponent(0.2)
        selectedBgButton.selectedBackgroundColor = .systemRed.withAlphaComponent(0.8) // 设置选中背景色
        selectedBgButton.layer.cornerRadius = 12
        selectedBgButton.imagePosition = .left
        selectedBgButton.spacing = 8
        selectedBgButton.addTarget(self, action: #selector(toggleSelectedState(_:)), for: .touchUpInside)
        
        // 选中图片测试按钮
        let selectedImageButton = ChimpionButton()
        selectedImageButton.setTitle("选中图片", for: .normal)
        selectedImageButton.setImage(UIImage(systemName: "star"), for: .normal) // 未选中时为空心星
        selectedImageButton.selectedImage = UIImage(systemName: "star.fill") // 选中时为实心星
        selectedImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectedImageButton.setTitleColor(.black, for: .normal)
        selectedImageButton.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        selectedImageButton.layer.cornerRadius = 12
        selectedImageButton.imagePosition = .left
        selectedImageButton.spacing = 8
        selectedImageButton.addTarget(self, action: #selector(toggleSelectedState(_:)), for: .touchUpInside)
        
        // 选中背景色和图片测试按钮
        let selectedBothButton = ChimpionButton()
        selectedBothButton.setTitle("选中背景和图片", for: .normal)
        selectedBothButton.setImage(UIImage(systemName: "checkmark"), for: .normal) // 未选中时为空心对勾
        selectedBothButton.selectedImage = UIImage(systemName: "checkmark.circle.fill") // 选中时为实心对勾
        selectedBothButton.translatesAutoresizingMaskIntoConstraints = false
        selectedBothButton.setTitleColor(.black, for: .normal)
        selectedBothButton.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        selectedBothButton.selectedBackgroundColor = .systemGreen.withAlphaComponent(0.8) // 设置选中背景色
        selectedBothButton.layer.cornerRadius = 12
        selectedBothButton.imagePosition = .left
        selectedBothButton.spacing = 8
        selectedBothButton.addTarget(self, action: #selector(toggleSelectedState(_:)), for: .touchUpInside)
        
        // 创建选中状态测试栈视图
        let selectedStackView = UIStackView(arrangedSubviews: [selectedBgButton, selectedImageButton, selectedBothButton])
        selectedStackView.axis = .vertical
        selectedStackView.spacing = 20
        selectedStackView.alignment = .center
        selectedStackView.distribution = .fillProportionally
        selectedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedStackView)
        
        // 设置选中状态测试按钮尺寸和约束
        NSLayoutConstraint.activate([
            selectedBgButton.widthAnchor.constraint(equalToConstant: 200),
            selectedBgButton.heightAnchor.constraint(equalToConstant: 50),
            
            selectedImageButton.widthAnchor.constraint(equalToConstant: 200),
            selectedImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            selectedBothButton.widthAnchor.constraint(equalToConstant: 200),
            selectedBothButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 设置选中状态测试栈视图约束
            selectedStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            selectedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: ChimpionButton) {
        print("按钮点击: \(sender.titleLabel.text ?? "未命名按钮")")
    }
    
    @objc private func toggleSelectedState(_ sender: ChimpionButton) {
        sender.isSelected.toggle()
        print("按钮 \(sender.titleLabel.text ?? "未命名按钮") 选中状态: \(sender.isSelected)")
    }
}
