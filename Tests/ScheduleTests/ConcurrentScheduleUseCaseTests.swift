import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class ConcurrentScheduleUseCaseTests: XCTestCase {
    func testConcFRFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ConcurrentScheduleUseCase = Conc(FR(5), FR(5))

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, ResponseEntity(numOfResponses: 7, milliseconds: 0)),
            Recorded.next(300, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
            Recorded.next(500, ResponseEntity(numOfResponses: 1000, milliseconds: 0)),
            Recorded.next(600, ResponseEntity(numOfResponses: 1001, milliseconds: 0)),
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
            Recorded.next(500, true),
            Recorded.next(600, false),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testConcFTFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ConcurrentScheduleUseCase = Conc(FT(5), FR(5))

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ResponseEntity(numOfResponses: 5, milliseconds: 0)),
            Recorded.next(200, ResponseEntity(numOfResponses: 7, milliseconds: 0)),
            Recorded.next(300, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
            Recorded.next(400, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
            Recorded.next(500, ResponseEntity(numOfResponses: 1000, milliseconds: 0)),
            Recorded.next(600, ResponseEntity(numOfResponses: 1001, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .flatMap { schedule.decision($0, index: 1) }
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
            Recorded.next(500, true),
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
