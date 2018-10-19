import RxSwift
import XCTest
@testable import OperantKit

final class OperantKitTests: XCTestCase {
    /// Tolerance delay (ms); Added for low spec test from CI.
    let toleranceDelay: Int = 100

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OperantKit().text, "Hello, World!")
    }

    func testTimer() {
        let targetMilliseconds: Int = Int(arc4random() % 500) + 100
        let timer = IntervalTimer(0.1)
        timer.start()
        usleep(UInt32(targetMilliseconds) * 1000)
        XCTAssertGreaterThanOrEqual(timer.elapsed.milliseconds.now.value, targetMilliseconds - self.toleranceDelay)
        timer.finish()
    }

    func testEvent() {
        let disposeBag = DisposeBag()
        let targetSeconds: Int = 1
        let timer = IntervalTimer(0.1, isDebug: true)
        var randomNumber: Int { return Int(arc4random() % UInt32(targetSeconds * 1000)) }
        let randomTimes: [Int] = [
            // 10 random events
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
            randomNumber,
        ].sorted()
        randomTimes.enumerated().forEach { timer.addAlerm((id: $0.offset, milliseconds: $0.element)) }
        timer.eventFlag.asObservable()
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { event in
                // Decision equal event time and ids
                XCTAssertEqual(event.milliseconds, randomTimes[event.id])
                // Decision equal event time and current elapsed time
                XCTAssertGreaterThanOrEqual(timer.elapsed.milliseconds.now.value, event.milliseconds)
            })
            .disposed(by: disposeBag)
        timer.start()
        sleep(UInt32(targetSeconds))
        XCTAssertGreaterThanOrEqual(timer.elapsed.milliseconds.now.value, targetSeconds * 1000 - self.toleranceDelay)
        timer.finish()
    }

    /// Test DEBUG print for great developers
    func testPrint() {
        #if DEBUG
        let disposeBag = DisposeBag()
        let targetSeconds: Int = 5
        let timer = IntervalTimer(0.1, isDebug: true)
        timer.debugText.asObservable()
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { text in
                print(text.split(separator: "\n").map { "### \($0)" }.joined(separator: "\n"), terminator: "\n\n")
            })
            .disposed(by: disposeBag)
        timer.start()
        sleep(UInt32(targetSeconds))
        XCTAssertGreaterThanOrEqual(timer.elapsed.milliseconds.now.value, targetSeconds * 1000 - self.toleranceDelay)
        timer.finish()
        #endif
    }

    static var allTests = [
        ("testExample", testExample),
        ("testTimer", testTimer),
        ("testPrint", testPrint),
    ]
}
