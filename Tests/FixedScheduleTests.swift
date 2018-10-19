import XCTest
@testable import OperantKit

final class FixedScheduleTests: XCTestCase {
    func testFR() {
        let schedule = FixedRatioSchedule()
        for _ in 0..<10 {
            let responses = Int.random(in: 1...10000)
            let value = Int.random(in: 1...10000)
            XCTAssertEqual(responses > value, schedule.decision(responses, value: value))
        }
    }

    func testFI() {
        let schedule = FixedIntervalSchedule()
        for _ in 0..<10 {
            let time = Int.random(in: 1...10000)
            let value = Int.random(in: 1...10000)
            XCTAssertEqual(time > value, schedule.decision(time, value: value))
        }
    }

    func testFT() {
        let schedule = FixedTimeSchedule()
        for _ in 0..<10 {
            let time = Int.random(in: 1...10000)
            let value = Int.random(in: 1...10000)
            XCTAssertEqual(time > value, schedule.decision(time, value: value))
        }
    }
}
