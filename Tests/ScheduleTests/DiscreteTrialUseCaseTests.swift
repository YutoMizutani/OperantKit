import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class DiscreteTrialScheduleUseCaseTests: XCTestCase {
    func testDiscreteFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: DiscreteTrialUseCase = DiscreteTrialUseCase(FR(2))

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, (true, ResponseEntity(numberOfResponses: 2, milliseconds: 0))),
            Recorded.next(200, (false, ResponseEntity(numberOfResponses: 4, milliseconds: 0))),
            Recorded.next(300, (true, ResponseEntity(numberOfResponses: 4, milliseconds: 0))),
            Recorded.next(400, (true, ResponseEntity(numberOfResponses: 6, milliseconds: 0))),
            Recorded.next(500, (true, ResponseEntity(numberOfResponses: 6, milliseconds: 0))),
            Recorded.next(600, (false, ResponseEntity(numberOfResponses: 6, milliseconds: 0))),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .flatMap { b, e in b ? schedule.nextTrial().map { e } : Single.just(e) }
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
            Recorded.next(400, true),
            Recorded.next(500, false),
            Recorded.next(600, false),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
