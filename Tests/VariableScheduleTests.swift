import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class VariableScheduleTests: XCTestCase {
    func testVRWithCertainty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let schedule: ScheduleUseCase = VR(5)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponse: 100, milliseconds: 0)),
            next(200, ResponseEntity(numOfResponse: 200, milliseconds: 0)),
            next(300, ResponseEntity(numOfResponse: 300, milliseconds: 0)),
            next(400, ResponseEntity(numOfResponse: 400, milliseconds: 0)),
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
        let schedule: ScheduleUseCase = VariableRatioScheduleUseCase(value: 5, values: values)

        let testObservable = scheduler.createHotObservable([
            next(100, ResponseEntity(numOfResponse: 5, milliseconds: 0)),
            next(200, ResponseEntity(numOfResponse: 7, milliseconds: 0)),
            next(300, ResponseEntity(numOfResponse: 10, milliseconds: 0)),
            next(400, ResponseEntity(numOfResponse: 10, milliseconds: 0)),
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
