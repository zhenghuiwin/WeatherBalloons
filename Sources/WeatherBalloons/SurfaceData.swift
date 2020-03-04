//
//  SurfaceData.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/13.
//

import Foundation

public class SurfaceData {
    
    public init() {}
    
    @available(OSX 10.12, *)
    public func getData(param: RequestParam, timeout: DispatchTime, resultHandle: @escaping (Data?, URLResponse?, ResponseError?) -> Void) throws {
        let urls = try param.requestURL()
        
        let semaphore = DispatchSemaphore(value: 0)
        var count = urls.count
        for url in urls {
            let task = URLSession.shared.dataTask(with: url) {(data, rep, error) in
                
                defer {
                    count -= 1
                    if count == 0 {
                        semaphore.signal()
                    }
                }
                
                if error != nil {
                    resultHandle(data, rep, ResponseError(sourceError: error!, taskURL: url))
                    return
                }
                
                resultHandle(data, rep, nil)
            }
            
            task.resume()
        }
        _ = semaphore.wait(timeout: timeout)
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
