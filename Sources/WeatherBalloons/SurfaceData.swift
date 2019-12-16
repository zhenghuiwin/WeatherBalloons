//
//  SurfaceData.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/13.
//

import Foundation

public class SurfaceData {
    @available(OSX 10.12, *)
    public func getData(param: RequestParam, timeout: DispatchTime, resultHandle: @escaping (Data) -> Void) throws {
        let urls = try param.requestURL()
        
        let semaphore = DispatchSemaphore(value: 0)
        var count = urls.count
        for url in urls {
            print(url)
            let task = URLSession.shared.dataTask(with: url) {(data, rep, error) in
                
                defer {
                    print("URLSession.shared.dataTask: signal")
                    count -= 1
                    if count == 0 {
                        semaphore.signal()
                    }
                }
                
                if error != nil {
                    print("URLSession.shared.dataTask error: \(error!.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                resultHandle(data)
            }
            
            task.resume()
        }
        _ = semaphore.wait(timeout: timeout)
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
