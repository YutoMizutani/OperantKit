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
            next(100, (true, ResponseEntity(numOfResponses: 2, milliseconds: 0))),
            next(200, (false, ResponseEntity(numOfResponses: 4, milliseconds: 0))),
            next(300, (true, ResponseEntity(numOfResponses: 4, milliseconds: 0))),
            next(400, (true, ResponseEntity(numOfResponses: 6, milliseconds: 0))),
            next(500, (true, ResponseEntity(numOfResponses: 6, milliseconds: 0))),
            next(600, (false, ResponseEntity(numOfResponses: 6, milliseconds: 0))),
            completed(completedTime)
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
            next(100, true),
            next(200, false),
            next(300, true),
            next(400, true),
            next(500, false),
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
