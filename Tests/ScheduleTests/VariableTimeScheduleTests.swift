import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class VariableTimeScheduleTests: XCTestCase {
    func testVTWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = VT(5)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponses: 0, milliseconds: 5000 * 100)),
            next(200, ResponseEntity(numOfResponses: 0, milliseconds: 10000 * 100)),
            next(300, ResponseEntity(numOfResponses: 0, milliseconds: 15000 * 100)),
            next(400, ResponseEntity(numOfResponses: 0, milliseconds: 20000 * 100)),
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
            next(100, true),
            next(200, true),
            next(300, true),
            next(400, true),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testVTWithManualArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let values: [Milliseconds] = [5, 5, 5]
        let schedule: ScheduleUseCase = VT(5, values: values)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponses: 0, milliseconds: 5)),
            next(200, ResponseEntity(numOfResponses: 0, milliseconds: 7)),
            next(300, ResponseEntity(numOfResponses: 0, milliseconds: 10)),
            next(400, ResponseEntity(numOfResponses: 0, milliseconds: 10)),
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
            next(100, true),
            next(200, false),
            next(300, true),
            next(400, false),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
