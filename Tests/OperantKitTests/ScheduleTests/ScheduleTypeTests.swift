import XCTest
@testable import OperantKit

final class ScheduleTypeTests: XCTestCase {
    func testHasFixedSchedule() {
        XCTAssertTrue(ScheduleType.FixedRatio.hasFixedSchedule())
        XCTAssertTrue(ScheduleType.FixedInterval.hasFixedSchedule())
        XCTAssertTrue(ScheduleType.FixedTime.hasFixedSchedule())

        XCTAssertFalse(ScheduleType.VariableRatio.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.VariableInterval.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.VariableTime.hasFixedSchedule())

        XCTAssertFalse(ScheduleType.RandomRatio.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.RandomInterval.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.RandomTime.hasFixedSchedule())
    }

    func testHasVariableSchedule() {
        XCTAssertFalse(ScheduleType.FixedRatio.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.FixedInterval.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.FixedTime.hasVariableSchedule())

        XCTAssertTrue(ScheduleType.VariableRatio.hasVariableSchedule())
        XCTAssertTrue(ScheduleType.VariableInterval.hasVariableSchedule())
        XCTAssertTrue(ScheduleType.VariableTime.hasVariableSchedule())

        XCTAssertFalse(ScheduleType.RandomRatio.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.RandomInterval.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.RandomTime.hasVariableSchedule())
    }

    func testHasRandomSchedule() {
        XCTAssertFalse(ScheduleType.FixedRatio.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.FixedInterval.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.FixedTime.hasRandomSchedule())

        XCTAssertFalse(ScheduleType.VariableRatio.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.VariableInterval.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.VariableTime.hasRandomSchedule())

        XCTAssertTrue(ScheduleType.RandomRatio.hasRandomSchedule())
        XCTAssertTrue(ScheduleType.RandomInterval.hasRandomSchedule())
        XCTAssertTrue(ScheduleType.RandomTime.hasRandomSchedule())
    }

    func testHasRatioSchedule() {

    }

    func testHasIntervalSchedule() {

    }

    func testHasTimeSchedule() {

    }
}
