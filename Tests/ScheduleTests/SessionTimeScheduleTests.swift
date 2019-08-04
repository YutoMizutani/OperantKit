import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class SessionTimeTests: XCTestCase {
    func testStructSessionTime() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 300
        let disposeBag = DisposeBag()

        let testObservable: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5, milliseconds: 100)),
            Recorded.next(200, Response(numberOfResponses: 7, milliseconds: 200)),
            Recorded.next(300, Response(numberOfResponses: 10, milliseconds: completedTime)),
            Recorded.next(400, Response(numberOfResponses: 10, milliseconds: 400)),
            Recorded.next(500, Response(numberOfResponses: 1000, milliseconds: 500)),
            Recorded.next(600, Response(numberOfResponses: 1001, milliseconds: 600)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = FR(5)
            .sessionTime(.milliseconds(completedTime))
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
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testMethodChainSessionTime() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 300
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5, milliseconds: 100)),
            Recorded.next(200, Response(numberOfResponses: 7, milliseconds: 200)),
            Recorded.next(300, Response(numberOfResponses: 10, milliseconds: completedTime)),
            Recorded.next(400, Response(numberOfResponses: 10, milliseconds: 400)),
            Recorded.next(500, Response(numberOfResponses: 1000, milliseconds: 500)),
            Recorded.next(600, Response(numberOfResponses: 1001, milliseconds: 600)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .fixedRatio(5)
                .sessionTime(.milliseconds(completedTime))
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, true),
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
