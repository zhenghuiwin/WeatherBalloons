import XCTest
@testable import WeatherBalloons

final class WeatherBalloonsTests: XCTestCase {
    
    var fmt: DateFormatter  {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = TimeZone(identifier: "UTC")
        return df
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WeatherBalloons().text, "Hello, World!")
    }
    
    @available(OSX 10.12, *)
    func testTimeRangeSlice00() {
        let start = fmt.date(from: "20191201000000")!
        let end = fmt.date(from:   "20191203000000")!
        let interval = DateInterval(start: start, end: end)
        
        let slice: [DateInterval] = Utils.timeRangeSlice(interval: interval, days: 1)
        XCTAssertEqual(slice.count, 2)
        
        let first: DateInterval = slice[0]
        XCTAssertEqual(fmt.date(from: "20191201000000"), first.start)
        XCTAssertEqual(fmt.date(from: "20191202000000"), first.end)
        
        let second: DateInterval = slice[1]
        XCTAssertEqual(fmt.date(from: "20191202010000"), second.start)
        XCTAssertEqual(fmt.date(from: "20191203000000"), second.end)
    }
    
    @available(OSX 10.12, *)
    func testTimeRangeSlice01() {
        let start = fmt.date(from: "20191201000000")!
        let end = fmt.date(from:   "20191203030000")!
        let interval = DateInterval(start: start, end: end)
        
        let slice: [DateInterval] = Utils.timeRangeSlice(interval: interval, days: 1)
        XCTAssertEqual(slice.count, 3)
        
        let first: DateInterval = slice[0]
        XCTAssertEqual(fmt.date(from: "20191201000000"), first.start)
        XCTAssertEqual(fmt.date(from: "20191202000000"), first.end)

        let second: DateInterval = slice[1]
        XCTAssertEqual(fmt.date(from: "20191202010000"), second.start)
        XCTAssertEqual(fmt.date(from: "20191203010000"), second.end)
        
        let third: DateInterval = slice[2]
        XCTAssertEqual(fmt.date(from: "20191203020000"), third.start)
        XCTAssertEqual(fmt.date(from: "20191203030000"), third.end)
    }
    
    
    @available(OSX 10.12, *)
    func testTimeRangeSlice02() {
        let start = fmt.date(from: "20191201000000")!
        let end = fmt.date(from:   "20191201000000")!
        let interval = DateInterval(start: start, end: end)
        
        let slice: [DateInterval] = Utils.timeRangeSlice(interval: interval, days: 1)
        XCTAssertEqual(slice.count, 1)
        
        let one: DateInterval = slice[0]
        XCTAssertEqual(fmt.date(from: "20191201000000"), one.start)
        XCTAssertEqual(fmt.date(from: "20191201000000"), one.end)
//
//        let second: DateInterval = slice[1]
//        XCTAssertEqual(fmt.date(from: "20191202010000"), second.start)
//        XCTAssertEqual(fmt.date(from: "20191203010000"), second.end)
//
//        let third: DateInterval = slice[2]
//        XCTAssertEqual(fmt.date(from: "20191203020000"), third.start)
//        XCTAssertEqual(fmt.date(from: "20191203030000"), third.end)
    }
    
    func testParams() {
        let params: [String : String] = [:] //["A": "a", "B":"b"]
        let paramPairs: String = params.filter({ (key, value) -> Bool in
            return key != "times" && key != "timeRange"
        }).map { (key, value) -> String in
             return "\(key)=\(value)"
        }.joined(separator: "&")
        
        print("paramPairs: \(paramPairs.count)")
    }
    
    @available(OSX 10.12, *)
    func testParamsURL() throws {
        let confg = try Config.load()
        let param = try RequestParam(
                                 interface: "getSurfEleInRegionByTimeRange",
                                 dataCode: "SURF_CHN_MUL_HOR_N",
                                 elements: ["Station_Name","Station_Id_C","TEM", "Datetime"],
                                 params: ["dataFormat" : "json", "adminCodes": "510800"],
                                 config: confg,
                                 timeRange: ["20191201000000", "20191202000000"])
        
        let urls = try param.requestURL()
        
        let sfData = SurfaceData()
        try sfData.getData(param: param, timeout: DispatchTime.distantFuture) { (data)  in
            if let out =  String(data: data, encoding: String.Encoding.utf8) {
                print(out)
                do {
                    try out.write(to: URL(fileURLWithPath: "./data/out.json"), atomically: false, encoding: String.Encoding.utf8)
                } catch let e {
                    print(e.localizedDescription)
                }
            }
        }
    }
    


    @available(OSX 10.12, *)
    static var allTests = [
        ("testExample", testExample),
        ("testTimeRangeSlice00", testTimeRangeSlice00),
        ("testTimeRangeSlice01", testTimeRangeSlice01),
        ("testTimeRangeSlice02", testTimeRangeSlice02),
        ("testParams", testParams),
        ("testParamsURL", testParamsURL)
    ]
}
