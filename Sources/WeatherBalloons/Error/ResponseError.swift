//
//  ResponseError.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2020/3/4.
//

import Foundation

public struct ResponseError {
    public let sourceError: Error
    public let taskURL: URL
    
    public init(sourceError: Error, taskURL: URL) {
        self.sourceError = sourceError
        self.taskURL = taskURL
    }
}
