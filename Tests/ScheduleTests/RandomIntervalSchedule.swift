import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class RandomIntervalScheduleTests: XCTestCase {
    func testRI() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = RI(5)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numOfResponses: 0, milliseconds: 5000)),
            Recorded.next(200, ResponseEntity(numOfResponses: 0, milliseconds: 10000)),
            Recorded.next(300, ResponseEntity(numOfResponses: 0, milliseconds: 10000)),
            Recorded.next(400, ResponseEntity(numOfResponses: 0, milliseconds: 15000)),
            Recorded.next(500, ResponseEntity(numOfResponses: 0, milliseconds: 100000)),
            Recorded.next(1000, ResponseEntity(numOfResponses: 1, milliseconds: 500000)),
            Recorded.next(2000, ResponseEntity(numOfResponses: 2, milliseconds: 1000000)),
            Recorded.next(3000, ResponseEntity(numOfResponses: 3, milliseconds: 1000000)),
            Recorded.next(4000, ResponseEntity(numOfResponses: 4, milliseconds: 1500000)),
            Recorded.next(5000, ResponseEntity(numOfResponses: 5, milliseconds: 10000000)),
            Recorded.completed(completedTime)
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
            Recorded.next(100, false),
            Recorded.next(200, false),
            Recorded.next(300, false),
            Recorded.next(400, false),
            Recorded.next(500, false),
            Recorded.next(1000, true),
            Recorded.next(2000, true),
            Recorded.next(3000, false),
            Recorded.next(4000, true),
            Recorded.next(5000, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
