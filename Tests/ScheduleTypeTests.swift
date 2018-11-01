import XCTest
@testable import OperantKit

final class ScheduleTypeTests: XCTestCase {
    func testHasFixedSchedule() {
        XCTAssertTrue(ReinforcementSchedule.FixedRatio.hasFixedSchedule())
        XCTAssertTrue(ReinforcementSchedule.FixedInterval.hasFixedSchedule())
        XCTAssertTrue(ReinforcementSchedule.FixedTime.hasFixedSchedule())

        XCTAssertFalse(ReinforcementSchedule.VariableRatio.hasFixedSchedule())
        XCTAssertFalse(ReinforcementSchedule.VariableInterval.hasFixedSchedule())
        XCTAssertFalse(ReinforcementSchedule.VariableTime.hasFixedSchedule())

        XCTAssertFalse(ReinforcementSchedule.RandomRatio.hasFixedSchedule())
        XCTAssertFalse(ReinforcementSchedule.RandomInterval.hasFixedSchedule())
        XCTAssertFalse(ReinforcementSchedule.RandomTime.hasFixedSchedule())
    }

    func testHasVariableSchedule() {
        XCTAssertFalse(ReinforcementSchedule.FixedRatio.hasVariableSchedule())
        XCTAssertFalse(ReinforcementSchedule.FixedInterval.hasVariableSchedule())
        XCTAssertFalse(ReinforcementSchedule.FixedTime.hasVariableSchedule())

        XCTAssertTrue(ReinforcementSchedule.VariableRatio.hasVariableSchedule())
        XCTAssertTrue(ReinforcementSchedule.VariableInterval.hasVariableSchedule())
        XCTAssertTrue(ReinforcementSchedule.VariableTime.hasVariableSchedule())

        XCTAssertFalse(ReinforcementSchedule.RandomRatio.hasVariableSchedule())
        XCTAssertFalse(ReinforcementSchedule.RandomInterval.hasVariableSchedule())
        XCTAssertFalse(ReinforcementSchedule.RandomTime.hasVariableSchedule())
    }

    func testHasRandomSchedule() {
        XCTAssertFalse(ReinforcementSchedule.FixedRatio.hasRandomSchedule())
        XCTAssertFalse(ReinforcementSchedule.FixedInterval.hasRandomSchedule())
        XCTAssertFalse(ReinforcementSchedule.FixedTime.hasRandomSchedule())

        XCTAssertFalse(ReinforcementSchedule.VariableRatio.hasRandomSchedule())
        XCTAssertFalse(ReinforcementSchedule.VariableInterval.hasRandomSchedule())
        XCTAssertFalse(ReinforcementSchedule.VariableTime.hasRandomSchedule())

        XCTAssertTrue(ReinforcementSchedule.RandomRatio.hasRandomSchedule())
        XCTAssertTrue(ReinforcementSchedule.RandomInterval.hasRandomSchedule())
        XCTAssertTrue(ReinforcementSchedule.RandomTime.hasRandomSchedule())
    }

    func testHasRatioSchedule() {

    }

    func testHasIntervalSchedule() {

    }

    func testHasTimeSchedule() {

    }
}
