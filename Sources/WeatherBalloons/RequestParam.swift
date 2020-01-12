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
//    let timeRange: [String]
    let timeType: TimeType
    
    var fmt: DateFormatter  {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = TimeZone(identifier: "UTC")
        return df
    }
    
   
    
    public init(interface: String, dataCode: String, elements: [String], params: [String : String], config: ConfigInfo, timeType: TimeType) {
        self.interface = interface
        self.dataCode = dataCode
        self.elements = elements
        self.params = params
        self.config = config
        self.timeType = timeType
    }
    
    
    ///
    ///  - Throws: TimeError.InvalidTime
    public func requestURL() throws -> [URL] {
        var urlStr =
            "\(config.host)?"           +
            "userId=\(config.user)"     +
            "&pwd=\(config.pawd)"       +
            "&interfaceId=\(interface)" +
            "&dataCode=\(dataCode)"
        
        
        let paramPairs: String = params.filter({ (key, value) -> Bool in
            return key != "times" && key != "timeRange" && key != "time"
        }).map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        if paramPairs.count > 0 {
             urlStr += "&\(paramPairs)"
        }
        
        if elements.count > 0 {
            urlStr += "&elements=\(elements.joined(separator: ","))"
        }
        
        return try urls(with: timeType, for: urlStr)
    }
    
    ///
    /// - Throws: TimeError.InvalidTime
    private func urls(with timeType: TimeType, for urlBase: String) throws -> [URL] {
        switch timeType {
        case .time(let time):
            let newUrl = "\(urlBase)&time=\(time)"
            guard let url = encodedURL(for: newUrl) else {
                return []
            }
            
            return [url]
        case .timeRange(let start, let end):
            let timeRange: DateInterval = try timeInterval(start: start, end: end)
            let timeRangeSlice: [DateInterval] = Utils.timeRangeSlice(
                interval: timeRange,
                days: config.intervalDays
            )
            
            let urlsString: [String] = timeRangeSlice.map { (slice) -> String in
                let sliceString = "[\(fmt.string(from: slice.start)),\(fmt.string(from: slice.end))]"
                return "\(urlBase)&timeRange=\(sliceString)"
            }
            
            var urls: [URL] = []
            urlsString.forEach { (urlString) in
                if let url = encodedURL(for: urlString) {
                    urls.append(url)
                }
            }
            
            return urls
        case .times(let times):
            let newUrl = "\(urlBase)&times=\(times.joined(separator: ","))"
            guard let url = encodedURL(for: newUrl) else {
                return []
            }
            
            return [url]
        }
    }
    
    
    private func encodedURL(for urlString: String) -> URL? {
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: encoded) else {
                print("Invalid URL: \(urlString)")
                return nil
        }
        
        return url
    }
    
    /// - Throws:  TimeError.InvalidTime
    private func timeInterval(start: String, end: String) throws -> DateInterval {
        guard let sDate = fmt.date(from: start) else {
            throw TimeError.InvalidTime
        }
        
        guard let eDate = fmt.date(from: end) else {
            throw TimeError.InvalidTime
        }
        
        return DateInterval(start: sDate, end: eDate)
    }
}
