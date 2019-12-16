//
//  RequestParam.swift
//  WeatherBalloons
//
//  Created by zhenghuiwin on 2019/12/13.
//

import Foundation

@available(OSX 10.12, *)
public struct RequestParam {
    let interface: String
    let dataCode: String
    let elements: [String]
    let params: [String : String]
    let config: ConfigInfo
    let timeRange: [String]
    
    var fmt: DateFormatter  {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = TimeZone(identifier: "UTC")
        return df
    }
    
   
    
    init(interface: String, dataCode: String, elements: [String], params: [String : String], config: ConfigInfo, timeRange: [String]) {
        self.interface = interface
        self.dataCode = dataCode
        self.elements = elements
        self.params = params
        self.config = config
        self.timeRange = timeRange
    }
    
    public func requestURL() throws -> [URL] {
        let interval = try timeInterval()
        let timeSlice: [DateInterval] = Utils.timeRangeSlice(
            interval: interval,
            days: config.intervalDays
        )
        
        var urlStr =
            "\(config.host)?"           +
            "userId=\(config.user)"     +
            "&pwd=\(config.pawd)"       +
            "&interfaceId=\(interface)" +
            "&dataCode=\(dataCode)"
        
        
        let paramPairs: String = params.filter({ (key, value) -> Bool in
            return key != "times" && key != "timeRange"
        }).map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        if paramPairs.count > 0 {
             urlStr += "&\(paramPairs)"
        }
        
        if elements.count > 0 {
            urlStr += "&elements=\(elements.joined(separator: ","))"
        }
        
        
        var urlStrs: [String] = []
        
        if timeSlice.count == 1
            && timeSlice[0].start.compare(timeSlice[0].end) == .orderedSame {
            // Only a single time
            urlStrs.append("\(urlStr)&times=\(fmt.string(from: timeSlice[0].start))")
        } else {
            timeSlice.map { (range) -> String in
               return "[\(fmt.string(from: range.start)),\(fmt.string(from: range.end))]"
            }.forEach { (r) in
               urlStrs.append("\(urlStr)&timeRange=\(r)")
            }
        }
        
        var urls: [URL] = []
        urlStrs.forEach { (url) in
            guard let encoded = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let url = URL(string: encoded) else {
                    print("Invalid URL: \(urlStr)")
                    return
            }
            urls.append(url)
        }
        
        return urls
    }
    
    
    /// -Throws:  TimeError.InvalidTime
    private func timeInterval() throws -> DateInterval {
        guard timeRange.count >= 1,
              let start = fmt.date(from: timeRange.first!) else {
            throw TimeError.InvalidTime
        }
        
        if timeRange.count == 1 {
            return DateInterval(start: start, end: start)
        }
        
        guard let end = fmt.date(from: timeRange[1]) else {
            throw TimeError.InvalidTime
        }
        
        
        if start.compare(end) == .orderedDescending {
            return DateInterval(start: end, end: start)
        }
        
        return DateInterval(start: start, end: end)
    }
}
