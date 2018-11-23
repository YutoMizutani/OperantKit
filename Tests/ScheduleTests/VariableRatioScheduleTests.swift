import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class VariableRatioScheduleTests: XCTestCase {
    func testVRWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = VR(5)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponses: 5 * 100, milliseconds: 0)),
            next(200, ResponseEntity(numOfResponses: 10 * 100, milliseconds: 0)),
            next(300, ResponseEntity(numOfResponses: 15 * 100, milliseconds: 0)),
            next(400, ResponseEntity(numOfResponses: 20 * 100, milliseconds: 0)),
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

    func testVRWithManualArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let values: [Int] = [5, 5, 5]
        let schedule: ScheduleUseCase = VR(5, values: values)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponses: 5, milliseconds: 0)),
            next(200, ResponseEntity(numOfResponses: 7, milliseconds: 0)),
            next(300, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
            next(400, ResponseEntity(numOfResponses: 10, milliseconds: 0)),
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
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
