// 简单的语法测试文件
import UIKit

// 导入RouterManager
import MyToolLibrary

// 测试RouterManager的基本功能
let router = RouterManager.shared

// 注册一个简单的路由
router.register(path: "/home") { (vc, params) -> Bool in
    print("Home route called with params: \(params)")
    return true
}

// 尝试路由
router.route(to: "app://home?name=test")

print("语法测试完成!")
