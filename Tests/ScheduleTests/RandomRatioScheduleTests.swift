import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class RandomRatioScheduleTests: XCTestCase {
    func testRR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = RR(5)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, ResponseEntity(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(300, ResponseEntity(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, ResponseEntity(numberOfResponses: 15, milliseconds: 0)),
            Recorded.next(500, ResponseEntity(numberOfResponses: 1000, milliseconds: 0)),
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
            Recorded.next(100, true),
            Recorded.next(200, true),
            Recorded.next(300, false),
            Recorded.next(400, true),
            Recorded.next(500, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
