import RxSwift
import XCTest
@testable import OperantKit

final class OperantKitTests: XCTestCase {
    /// Tolerance delay (ms); Added for low spec test from CI.
    let toleranceDelay: Int = 100

    #if os(macOS)
    /// Correct time test
    func testTimer() {
        let targetMilliseconds: Int = Int(arc4random() % 500) + 100
        let timer = IntervalTimer(0.1)
        timer.start()
        usleep(UInt32(targetMilliseconds) * 1000)
        XCTAssertGreaterThanOrEqual(timer.milliseconds, targetMilliseconds - self.toleranceDelay)
        timer.finish()
    }
    #endif
}
