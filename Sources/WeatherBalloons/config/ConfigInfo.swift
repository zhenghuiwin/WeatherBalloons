//
//  Config.swift
//  RGF_Monitor
//
//  Created by zhenghuiwin on 2018/10/14.
//

import Foundation

public struct ConfigInfo: Codable {
    public let host: String
    public let user: String
    public let pawd: String
    public let intervalDays: Int
}

