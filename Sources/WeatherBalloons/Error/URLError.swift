//
//  URLError.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/14.
//

import Foundation

public enum URLError: Error {
    case InvalidURL
    
    var localizedDescription: String {
        switch self {
        case .InvalidURL:
            return "Invalid URL"
        }
    }
}
