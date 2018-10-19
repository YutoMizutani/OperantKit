import XCTest
@testable import OperantKit

final class ExtinctionScheduleTests: XCTestCase {
    func testExtension() {
        let schedule = ExtinctionSchedule()
        XCTAssertFalse(schedule.decision())
    }
}
