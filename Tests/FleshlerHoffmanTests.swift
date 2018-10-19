import RxSwift
import XCTest
@testable import OperantKit

final class FleshlerHoffmanTests: XCTestCase {
    var fleshlerHoffman: FleshlerHoffman!

    override func setUp() {
        super.setUp()

        self.fleshlerHoffman = FleshlerHoffman()
    }

    func testGeneratedVariableInterval() {
        XCTAssertEqual([], self.fleshlerHoffman.generatedInterval(value: Int.random(in: 0...10000), iterations: 0))

        for _ in 0..<10 {
            let value = Int.random(in: 1...10000)
            let iterations = Int.random(in: 1...10000)
            let vi = self.fleshlerHoffman.generatedInterval(value: value, iterations: iterations)
            XCTAssertEqual(vi.reduce(0, { $0 + $1 }), value * iterations)
        }
    }

    func testGeneratedVariableRatio() {
        XCTAssertEqual([], self.fleshlerHoffman.generatedRatio(value: Int.random(in: 0...10000), iterations: 0))

        for _ in 0..<10 {
            let value = Int.random(in: 1...10000)
            let iterations = Int.random(in: 1...10000)
            let vi = self.fleshlerHoffman.generatedRatio(value: value, iterations: iterations)
            XCTAssertEqual(vi.reduce(0, { $0 + $1 }), value * iterations)
        }
    }

    func testGeneratedHantula() {
        XCTAssertEqual([], self.fleshlerHoffman.hantula1991(value: Int.random(in: 0...10000), number: 0))
    }
}
