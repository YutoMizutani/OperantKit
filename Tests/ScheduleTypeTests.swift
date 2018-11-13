import XCTest
@testable import OperantKit

final class ScheduleTypeTests: XCTestCase {
    func testHasFixedSchedule() {
        XCTAssertTrue(ScheduleType.fixedRatio.hasFixedSchedule())
        XCTAssertTrue(ScheduleType.fixedInterval.hasFixedSchedule())
        XCTAssertTrue(ScheduleType.fixedTime.hasFixedSchedule())

        XCTAssertFalse(ScheduleType.variableRatio.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.variableInterval.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.variableTime.hasFixedSchedule())

        XCTAssertFalse(ScheduleType.randomRatio.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.randomInterval.hasFixedSchedule())
        XCTAssertFalse(ScheduleType.randomTime.hasFixedSchedule())
    }

    func testHasVariableSchedule() {
        XCTAssertFalse(ScheduleType.fixedRatio.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.fixedInterval.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.fixedTime.hasVariableSchedule())

        XCTAssertTrue(ScheduleType.variableRatio.hasVariableSchedule())
        XCTAssertTrue(ScheduleType.variableInterval.hasVariableSchedule())
        XCTAssertTrue(ScheduleType.variableTime.hasVariableSchedule())

        XCTAssertFalse(ScheduleType.randomRatio.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.randomInterval.hasVariableSchedule())
        XCTAssertFalse(ScheduleType.randomTime.hasVariableSchedule())
    }

    func testHasRandomSchedule() {
        XCTAssertFalse(ScheduleType.fixedRatio.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.fixedInterval.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.fixedTime.hasRandomSchedule())

        XCTAssertFalse(ScheduleType.variableRatio.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.variableInterval.hasRandomSchedule())
        XCTAssertFalse(ScheduleType.variableTime.hasRandomSchedule())

        XCTAssertTrue(ScheduleType.randomRatio.hasRandomSchedule())
        XCTAssertTrue(ScheduleType.randomInterval.hasRandomSchedule())
        XCTAssertTrue(ScheduleType.randomTime.hasRandomSchedule())
    }

    func testHasRatioSchedule() {
        XCTAssertTrue(ScheduleType.fixedRatio.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.fixedInterval.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.fixedTime.hasRatioSchedule())

        XCTAssertTrue(ScheduleType.variableRatio.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.variableInterval.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.variableTime.hasRatioSchedule())

        XCTAssertTrue(ScheduleType.randomRatio.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.randomInterval.hasRatioSchedule())
        XCTAssertFalse(ScheduleType.randomTime.hasRatioSchedule())
    }

    func testHasIntervalSchedule() {
        XCTAssertFalse(ScheduleType.fixedRatio.hasIntervalSchedule())
        XCTAssertTrue(ScheduleType.fixedInterval.hasIntervalSchedule())
        XCTAssertFalse(ScheduleType.fixedTime.hasIntervalSchedule())

        XCTAssertFalse(ScheduleType.variableRatio.hasIntervalSchedule())
        XCTAssertTrue(ScheduleType.variableInterval.hasIntervalSchedule())
        XCTAssertFalse(ScheduleType.variableTime.hasIntervalSchedule())

        XCTAssertFalse(ScheduleType.randomRatio.hasIntervalSchedule())
        XCTAssertTrue(ScheduleType.randomInterval.hasIntervalSchedule())
        XCTAssertFalse(ScheduleType.randomTime.hasIntervalSchedule())
    }

    func testHasTimeSchedule() {
        XCTAssertFalse(ScheduleType.fixedRatio.hasTimeSchedule())
        XCTAssertFalse(ScheduleType.fixedInterval.hasTimeSchedule())
        XCTAssertTrue(ScheduleType.fixedTime.hasTimeSchedule())

        XCTAssertFalse(ScheduleType.variableRatio.hasTimeSchedule())
        XCTAssertFalse(ScheduleType.variableInterval.hasTimeSchedule())
        XCTAssertTrue(ScheduleType.variableTime.hasTimeSchedule())

        XCTAssertFalse(ScheduleType.randomRatio.hasTimeSchedule())
        XCTAssertFalse(ScheduleType.randomInterval.hasTimeSchedule())
        XCTAssertTrue(ScheduleType.randomTime.hasTimeSchedule())
    }
}
