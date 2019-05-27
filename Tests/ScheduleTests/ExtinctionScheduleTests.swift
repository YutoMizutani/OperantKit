import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class ExtinctionScheduleTests: XCTestCase {
    func testEXT() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = EXT()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity.stub()),
            Recorded.next(200, ResponseEntity.stub()),
            Recorded.next(300, ResponseEntity.stub()),
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
            Recorded.next(100, false),
            Recorded.next(200, false),
            Recorded.next(300, false),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
