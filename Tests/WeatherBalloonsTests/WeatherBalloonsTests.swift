import XCTest
@testable import WeatherBalloons

final class WeatherBalloonsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WeatherBalloons().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
