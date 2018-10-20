import XCTest
@testable import OperantKit

final class ExtinctionScheduleTests: XCTestCase {
    func testEXT() {
        let schedule = ExtinctionSchedule()
        XCTAssertFalse(schedule.decision())
    }
}
