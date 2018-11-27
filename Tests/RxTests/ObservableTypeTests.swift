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
            next(100, 1),
            next(200, 2),
            next(300, 3),
            next(400, 4),
            next(500, 5),
            next(600, 6),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .scan(0) { n, _ in n + 1 }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            next(100, 1),
            next(200, 2),
            next(300, 3),
            next(400, 4),
            next(500, 5),
            next(600, 6),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testGetTimePublishSubject() {
        let timer = MockTimerUseCase(priority: .default)

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
            next(100, ()),
            next(200, ()),
            next(300, ()),
            next(400, ()),
            next(500, ()),
            next(600, ()),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .getTime(timer)
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            next(100, 1),
            next(200, 2),
            next(300, 3),
            next(400, 4),
            next(500, 5),
            next(600, 6),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testResponsePublishSubject() {
        let timer = MockTimerUseCase(priority: .default)

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
            next(100, ()),
            next(200, ()),
            next(300, ()),
            next(400, ()),
            next(500, ()),
            next(600, ()),
            completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .response(timer)
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            next(100, ResponseEntity(1, 1)),
            next(200, ResponseEntity(2, 2)),
            next(300, ResponseEntity(3, 3)),
            next(400, ResponseEntity(4, 4)),
            next(500, ResponseEntity(5, 5)),
            next(600, ResponseEntity(6, 6)),
            completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
