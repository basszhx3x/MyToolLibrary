//
//  CountryCodeInfo.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/13.
//

import Foundation
import SmartCodable

/// 国家数据分组模型
/// 
/// 用于存储按字母分组的国家列表数据
public struct CountrySectionListModel : Codable {
    /// 分组标识，通常为字母
    var key: String?
    /// 该分组下的国家数据列表
    var data: [CountryItemModel]?
}

/// 国家信息模型
/// 
/// 包含单个国家的详细信息
public struct CountryItemModel : Codable {
    
    /// 分组内的索引位置
    var index: Int = 0
    /// 国家名称（默认语言）
    var countryName: String?
    /// 国家编码缩写（如CN、US等）
    var countryCode: String?
    /// 国际电话区号
    var phoneCode: String?
    /// 英文名称
    var nameEn: String?
    /// 中文名称
    var nameCn: String?
    /// 香港地区使用的名称
    var nameHK: String?
    /// 国旗图片名称
    var flagImageName: String?
    
}

/// 国家代码信息管理类
/// 
/// 提供读取和管理国家代码数据的功能
public class CountryCodeInfo {
    
    /// 读取国家代码数据模型
    /// 
    /// 从bundle中加载并解析国家代码JSON数据
    /// - Returns: 解析后的国家分组数据数组，如果解析失败则返回空数组
    public static func readCountryModel() -> [CountrySectionListModel] {
        
        // 获取框架bundle路径
        let bundlePath = Bundle.init(for: CountryCodeInfo.self).path(forResource: "ChimpionTools", ofType: "bundle") ?? ""
        let bundle = Bundle(path: bundlePath)
        
        // 获取国家代码JSON文件路径
        let dataBundlePath = bundle?.path(forResource: "CountryCodeDataList", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: dataBundlePath)
        
        // 解析JSON数据
        do {
            // 读取文件数据
            let data = try Data(contentsOf: url)
            // 创建JSON解码器
            let decoder = JSONDecoder()
            // 解码数据到模型数组
            let model:[CountrySectionListModel] = try decoder.decode([CountrySectionListModel].self, from: data)
            return model
        } catch let error as Error? {
            // 处理可能的错误
            print("读取本地数据出现错误!\(error ?? "" as! Error)")
            return []
        }
    }
}
