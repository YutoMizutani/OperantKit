import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class VariableRatioScheduleTests: XCTestCase {
    func testStructVRWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5 * 100, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 10 * 100, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 15 * 100, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 20 * 100, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .variableRatio(5)
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, true),
            Recorded.next(200, true),
            Recorded.next(300, true),
            Recorded.next(400, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testStructVRWithManualArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let values: [Int] = [5, 5, 5]

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 7, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .variableRatio(values)
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, true),
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.next(400, false),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testMethodChainVRWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5 * 100, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 10 * 100, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 15 * 100, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 20 * 100, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = VR(5)
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
            Recorded.next(300, true),
            Recorded.next(400, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testMethodChainVRWithManualArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let values: [Int] = [5, 5, 5]

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 7, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 10, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .variableRatio(values)
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, true),
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.next(400, false),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
