import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class FixedScheduleTests: XCTestCase {
    func testFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = FR(5)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponse: 5, milliseconds: 0)),
            next(200, ResponseEntity(numOfResponse: 7, milliseconds: 0)),
            next(300, ResponseEntity(numOfResponse: 10, milliseconds: 0)),
            next(400, ResponseEntity(numOfResponse: 10, milliseconds: 0)),
            next(500, ResponseEntity(numOfResponse: 1000, milliseconds: 0)),
            next(600, ResponseEntity(numOfResponse: 1001, milliseconds: 0)),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            schedule.decision(
                testObservable.asObservable()
                )
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
            next(500, true),
            next(600, false),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
