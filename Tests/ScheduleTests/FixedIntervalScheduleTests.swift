import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class FixedIntervalScheduleTests: XCTestCase {
    func testFI() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = FI(5)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponses: 0, milliseconds: 5000)),
            next(200, ResponseEntity(numOfResponses: 0, milliseconds: 6000)),
            next(300, ResponseEntity(numOfResponses: 0, milliseconds: 10000)),
            next(400, ResponseEntity(numOfResponses: 0, milliseconds: 10000)),
            next(500, ResponseEntity(numOfResponses: 0, milliseconds: 1000000)),
            next(600, ResponseEntity(numOfResponses: 0, milliseconds: 1000001)),
            next(1000, ResponseEntity(numOfResponses: 1, milliseconds: 5000000)),
            next(2000, ResponseEntity(numOfResponses: 2, milliseconds: 5005000)),
            next(3000, ResponseEntity(numOfResponses: 3, milliseconds: 10000000)),
            next(4000, ResponseEntity(numOfResponses: 4, milliseconds: 10000000)),
            next(5000, ResponseEntity(numOfResponses: 5, milliseconds: 1000000000)),
            next(6000, ResponseEntity(numOfResponses: 6, milliseconds: 1000000001)),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .flatMap { schedule.decision($0) }
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            next(100, false),
            next(200, false),
            next(300, false),
            next(400, false),
            next(500, false),
            next(600, false),
            next(1000, true),
            next(2000, true),
            next(3000, true),
            next(4000, false),
            next(5000, true),
            next(6000, false),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
