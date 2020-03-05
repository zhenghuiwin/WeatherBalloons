//
//  SurfaceData.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/13.
//

import Foundation

public class SurfaceData {
    
    public init() {}
    
    /// Fetch the data synchronously from the DATA SERVER with the instance of `RequestParam`,
    /// the `resultHandle` will be invoked when the data returned.
    /// - Parameter param: An object of `RequestParam` which generate the request URL for
    ///                    fetching data from DATA SERVER.
    /// - Parameter timeout: The latest time to wait for a signal.
    /// - Parameter resultHandler: It will be invoked when the requested data be returned.
    ///     - Data?: The data be returned by the DATA SERVER.
    ///     - Int: The remaining number of tasks for fetching data.
    ///            If the total number of tasks is N, the first time the `resultHandler` be invoked,
    ///            it would be N - 1, the last time it would be 0.
    ///     - URLResponse?: An object that provides response metadata,
    ///                     such as HTTP headers and status code.
    ///                     If you are making an HTTP or HTTPS request,
    ///                     the returned object is actually an HTTPURLResponse object.
    ///     - ResponseError?: An object that record an error which occurred during
    ///                        one task execution and the related URL.
    @available(OSX 10.12, *)
    public func getDataSync(
        param: RequestParam,
        timeout: DispatchTime,
        resultHandler: @escaping (Data?, Int,  URLResponse?, ResponseError?) -> Void) throws {
        let urls = try param.requestURL()
        
        let semaphore = DispatchSemaphore(value: 0)
        var count = urls.count
        for url in urls {
            let task = URLSession.shared.dataTask(with: url) {(data, rep, error) in
                count -= 1
                defer {
                    if count == 0 {
                        semaphore.signal()
                    }
                }
                
                if error != nil {
                    resultHandler(data, count, rep, ResponseError(sourceError: error!, taskURL: url))
                    return
                }
                
                resultHandler(data, count, rep, nil)
            }
            
            task.resume()
        }
        _ = semaphore.wait(timeout: timeout)
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
