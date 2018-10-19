import XCTest
@testable import OperantKit

final class VariableScheduleTests: XCTestCase {
    func testVR() {
        let schedule = VariableRatioSchedule()

        let values = FleshlerHoffman().generatedRatio(value: Int.random(in: 1...100), iterations: 12)

        // Decision from previous SR parameters
        for _ in 0..<10 {
            let responses = Int.random(in: 0...10000)
            let prevSR = Int.random(in: 0...responses)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(responses - prevSR >= values[order], schedule.decision(responses - prevSR, value: values[order]))
        }

        // Decision from all array values
        for _ in 0..<10 {
            let responses = Int.random(in: 0...10000)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(responses >= values[0...order].reduce(0, { $0 + $1 }), schedule.decision(responses, value: values[0...order].reduce(0, { $0 + $1 })))
        }
    }

    func testVI() {
        let schedule = VariableIntervalSchedule()

        let values = FleshlerHoffman().generatedInterval(value: Int.random(in: 1...100) * 1000, iterations: 12)

        // Decision from previous SR parameters
        for _ in 0..<10 {
            let time = Int.random(in: 0...10000)
            let prevSR = Int.random(in: 0...time)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(time - prevSR >= values[order], schedule.decision(time - prevSR, value: values[order]))
        }

        // Decision from all array values
        for _ in 0..<10 {
            let time = Int.random(in: 0...10000)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(time >= values[0...order].reduce(0, { $0 + $1 }), schedule.decision(time, value: values[0...order].reduce(0, { $0 + $1 })))
        }
    }

    func testVT() {
        let schedule = VariableIntervalSchedule()

        let values = FleshlerHoffman().generatedInterval(value: Int.random(in: 1...100) * 1000, iterations: 12)

        // Decision from previous SR parameters
        for _ in 0..<10 {
            let time = Int.random(in: 0...10000)
            let prevSR = Int.random(in: 0...time)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(time - prevSR >= values[order], schedule.decision(time - prevSR, value: values[order]))
        }

        // Decision from all array values
        for _ in 0..<10 {
            let time = Int.random(in: 0...10000)
            let order = Int.random(in: 0..<values.count)
            XCTAssertEqual(time >= values[0...order].reduce(0, { $0 + $1 }), schedule.decision(time, value: values[0...order].reduce(0, { $0 + $1 })))
        }
    }
}
