import RxCocoa
import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class ObservableTypeTests: XCTestCase {
    let disposeBag = DisposeBag()

    func testCountPublishSubject() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 4),
            Recorded.next(500, 5),
            Recorded.next(600, 6),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .count()
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 4),
            Recorded.next(500, 5),
            Recorded.next(600, 6),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testGetTimePublishSubject() {
        let timer = StepTimerUseCase()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        Observable.just(())
            .flatMap { timer.start() }
            .subscribe()
            .disposed(by: disposeBag)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ()),
            Recorded.next(200, ()),
            Recorded.next(300, ()),
            Recorded.next(400, ()),
            Recorded.next(500, ()),
            Recorded.next(600, ()),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .getTime(timer)
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.next(400, 4),
            Recorded.next(500, 5),
            Recorded.next(600, 6),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testResponsePublishSubject() {
        let timer = StepTimerUseCase()

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ResponseEntity.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        Observable.just(())
            .flatMap { timer.start() }
            .subscribe()
            .disposed(by: disposeBag)

        let testObservable = scheduler.createHotObservable([
            Recorded.next(100, ()),
            Recorded.next(200, ()),
            Recorded.next(300, ()),
            Recorded.next(400, ()),
            Recorded.next(500, ()),
            Recorded.next(600, ()),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .response(timer)
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(100, ResponseEntity(1, 1)),
            Recorded.next(200, ResponseEntity(2, 2)),
            Recorded.next(300, ResponseEntity(3, 3)),
            Recorded.next(400, ResponseEntity(4, 4)),
            Recorded.next(500, ResponseEntity(5, 5)),
            Recorded.next(600, ResponseEntity(6, 6)),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
