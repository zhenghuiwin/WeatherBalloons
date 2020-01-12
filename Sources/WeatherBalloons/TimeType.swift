//
//  TimeTypwe.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2020/1/12.
//

import Foundation

public enum TimeType {
    case time(time: String)
    case times(times: [String])
    case timeRange(start: String, end: String)
}
