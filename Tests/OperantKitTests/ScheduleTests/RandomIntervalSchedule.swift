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
            next(100, ResponseEntity(numOfResponse: 0, milliseconds: 5000)),
            next(200, ResponseEntity(numOfResponse: 0, milliseconds: 10000)),
            next(300, ResponseEntity(numOfResponse: 0, milliseconds: 10000)),
            next(400, ResponseEntity(numOfResponse: 0, milliseconds: 15000)),
            next(500, ResponseEntity(numOfResponse: 0, milliseconds: 100000)),
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
            next(200, true),
            next(300, false),
            next(400, true),
            next(500, true),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
