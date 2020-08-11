import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class RandomTimeScheduleTests: XCTestCase {
    func testStructRI() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 0, milliseconds: 5000)),
            Recorded.next(200, Response(numberOfResponses: 0, milliseconds: 10000)),
            Recorded.next(300, Response(numberOfResponses: 0, milliseconds: 10000)),
            Recorded.next(400, Response(numberOfResponses: 0, milliseconds: 15000)),
            Recorded.next(500, Response(numberOfResponses: 0, milliseconds: 100000)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = RT(.seconds(5))
            .transform(testObservable.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable
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

    func testMethodChainRI() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 0, milliseconds: 5000)),
            Recorded.next(200, Response(numberOfResponses: 0, milliseconds: 10000)),
            Recorded.next(300, Response(numberOfResponses: 0, milliseconds: 10000)),
            Recorded.next(400, Response(numberOfResponses: 0, milliseconds: 15000)),
            Recorded.next(500, Response(numberOfResponses: 0, milliseconds: 100000)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .randomTime(.seconds(5))
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
