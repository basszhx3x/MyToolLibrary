//
//  CountryCodeInfo.swift
//  ChimpionTools
//
//  Created by basszhx3x on 2025/10/13.
//

import Foundation
import SmartCodable

public struct CountrySectionListModel : Codable {
    var key: String? // 分组可以
    var data: [CountryItemModel]? // 分组list
}

public struct CountryItemModel : Codable {
    
    var index: Int = 0 // 分组里面的索引
    var countryName: String? // 国家名字
    var countryCode: String? // 国家编码缩写
    var phoneCode: String? // 手机号编码
    var nameEn: String?
    var nameCn: String?
    var nameHK: String?
    var flagImageName: String?
    
}

public class CountryCodeInfo {
    
    public static func readCountryModel() -> [CountrySectionListModel] {
        
        let bundlePath = Bundle.init(for: CountryCodeInfo.self).path(forResource: "ChimpionTools", ofType: "bundle") ?? ""
        let bundle = Bundle(path: bundlePath)
        
        let dataBundlePath = bundle?.path(forResource: "CountryCodeDataList", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: dataBundlePath)
        
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let model:[CountrySectionListModel] = try decoder.decode([CountrySectionListModel].self, from: data)
            return model
        } catch let error as Error? {
            print("读取本地数据出现错误!\(error ?? "" as! Error)")
            return []
        }
    }
}
