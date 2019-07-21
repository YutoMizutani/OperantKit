import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class VariablIntervaleScheduleTests: XCTestCase {
    func testVIWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = VI(5)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numberOfResponses: 1, milliseconds: 5000 * 100)),
            Recorded.next(200, ResponseEntity(numberOfResponses: 2, milliseconds: 10000 * 100)),
            Recorded.next(300, ResponseEntity(numberOfResponses: 3, milliseconds: 15000 * 100)),
            Recorded.next(400, ResponseEntity(numberOfResponses: 4, milliseconds: 20000 * 100)),
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

    func testVIWithManualArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let values: [Milliseconds] = [5, 5, 5]
        let schedule: ScheduleUseCase = VI(5, values: values)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numberOfResponses: 1, milliseconds: 5)),
            Recorded.next(200, ResponseEntity(numberOfResponses: 2, milliseconds: 7)),
            Recorded.next(300, ResponseEntity(numberOfResponses: 3, milliseconds: 10)),
            Recorded.next(400, ResponseEntity(numberOfResponses: 4, milliseconds: 10)),
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
