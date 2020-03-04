//
//  ResponseError.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2020/3/4.
//

import Foundation

public struct ResponseError {
    let sourceError: Error
    let taskURL: URL
    
    public init(sourceError: Error, taskURL: URL) {
        self.sourceError = sourceError
        self.taskURL = taskURL
    }
}
