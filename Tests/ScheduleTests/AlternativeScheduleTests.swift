import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class AlternativeScheduleTests: XCTestCase {
    func testStructAlternativeFRFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(500, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(600, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = Alt(FR(2), FR(3))
            .transform(testObservable.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(200, true),
            Recorded.next(300, false),
            Recorded.next(400, true),
            Recorded.next(500, false),
            Recorded.next(600, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testStructAlternativeFRFI() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 1, milliseconds: 100)),
            Recorded.next(200, Response(numberOfResponses: 2, milliseconds: 200)),
            Recorded.next(300, Response(numberOfResponses: 3, milliseconds: 300)),
            Recorded.next(400, Response(numberOfResponses: 4, milliseconds: 400)),
            Recorded.next(500, Response(numberOfResponses: 5, milliseconds: 500)),
            Recorded.next(600, Response(numberOfResponses: 6, milliseconds: 600)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = Alt(FR(3), FI(.milliseconds(200)))
            .transform(testObservable.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(200, true),
            Recorded.next(300, false),
            Recorded.next(400, true),
            Recorded.next(500, false),
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
