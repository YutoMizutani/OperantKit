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

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity.stub()),
            next(200, ResponseEntity.stub()),
            next(300, ResponseEntity.stub()),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .asObservable()
                .EXT()
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            next(100, false),
            next(200, false),
            next(300, false),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
