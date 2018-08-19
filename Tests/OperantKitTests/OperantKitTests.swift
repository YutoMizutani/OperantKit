import XCTest
@testable import OperantKit

final class OperantKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OperantKit().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
