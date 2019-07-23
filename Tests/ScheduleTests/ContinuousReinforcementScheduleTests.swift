import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class ContinuousReinforcementScheduleTests: XCTestCase {
    func testCRF() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 7, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(500, Response(numberOfResponses: 1000, milliseconds: 0)),
            Recorded.next(600, Response(numberOfResponses: 1001, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .continuousReinforcement()
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, true),
            Recorded.next(200, true),
            Recorded.next(300, true),
            Recorded.next(400, false),
            Recorded.next(500, true),
            Recorded.next(600, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
