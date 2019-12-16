//
//  TimeError.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/14.
//

import Foundation

public enum TimeError: Error {
    case InvalidTime
    
    var localizedDescription: String {
        switch self {
        case .InvalidTime:
            return "Invalid time"
        }
    }
}
