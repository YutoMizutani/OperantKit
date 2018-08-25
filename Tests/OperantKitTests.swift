import XCTest
@testable import OperantKit

final class OperantKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OperantKit().text, "Hello, World!")
    }

    func testTimer() {
        let targetTime: Int = Int(arc4random() % 5) + 1
        let timer = IntervalTimer()
        timer.fire()
        sleep(UInt32(targetTime))
        XCTAssertGreaterThan(timer.elapsed.milliseconds.now.value, targetTime * 1000)
        timer.finish()
    }

    static var allTests = [
        ("testExample", testExample),
        ("testTimer", testTimer),
    ]
}
