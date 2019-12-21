//
//  Config.swift
//  RGF_Monitor
//
//  Created by zhenghuiwin on 2018/10/14.
//

import Foundation

public class Config {
    
    private static let configPath = "\(FileManager.default.currentDirectoryPath)/conf/BalloonsConf.json"
    
    public class func load() throws -> ConfigInfo {
        let configData = try Data(contentsOf: URL(fileURLWithPath: configPath))
        let jsonDecoder = JSONDecoder()
        let configInfo = try jsonDecoder.decode(ConfigInfo.self, from: configData)
        
        return configInfo
    }
    
    public class func save(configInfo: ConfigInfo) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(configInfo)
        
        try data.write(to: URL(fileURLWithPath: configPath))
    }
}
