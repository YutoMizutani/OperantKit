//
//  ConcurrentScheduleTests.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/25.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class ConcurrentScheduleTests: XCTestCase {
    func testStructSingleConsequenceConcurrentFRFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservableFirst: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(500, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(700, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(900, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(1100, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])
        let testObservableSecond: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(200, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(600, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(800, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(1000, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(1200, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = Conc(FR(2), FR(3))
            .transform(testObservableFirst.asObservable(), testObservableSecond.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.next(400, false),
            Recorded.next(500, false),
            Recorded.next(600, true),
            Recorded.next(700, true),
            Recorded.next(800, false),
            Recorded.next(900, false),
            Recorded.next(1000, false),
            Recorded.next(1100, true),
            Recorded.next(1200, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservableFirst.subscriptions, expectedSubscriptions)
        XCTAssertEqual(testObservableSecond.subscriptions, expectedSubscriptions)
    }

    func testStructEachConsequencesConcurrentFRFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observerFirst = scheduler.createObserver(Bool.self)
        let observerSecond = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservableFirst: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(500, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(700, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(900, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(1100, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])
        let testObservableSecond: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(200, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(600, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(800, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(1000, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(1200, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: [Observable<Consequence>] = Conc(FR(2), FR(3))
            .transform(testObservableFirst.asObservable(), testObservableSecond.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable[0]
                .map { $0.isReinforcement }
                .subscribe(observerFirst)
                .disposed(by: disposeBag)
            consequenceObservable[1]
                .map { $0.isReinforcement }
                .subscribe(observerSecond)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEventsFirst: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(300, true),
            Recorded.next(500, false),
            Recorded.next(700, true),
            Recorded.next(900, false),
            Recorded.next(1100, true),
            Recorded.completed(completedTime)
        ]
        let expectedEventsSecond: [Recorded<Event<Bool>>] = [
            Recorded.next(200, false),
            Recorded.next(400, false),
            Recorded.next(600, true),
            Recorded.next(800, false),
            Recorded.next(1000, false),
            Recorded.next(1200, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observerFirst.events, expectedEventsFirst)
        XCTAssertEqual(observerSecond.events, expectedEventsSecond)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservableFirst.subscriptions, expectedSubscriptions)
        XCTAssertEqual(testObservableSecond.subscriptions, expectedSubscriptions)
    }


    func testStructSingleResponseConcurrentFRFR() {
        let scheduler = TestScheduler(initialClock: 0)
        let observerFirst = scheduler.createObserver(Bool.self)
        let observerSecond = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(100, Response(numberOfResponses: 1, milliseconds: 0)),
            Recorded.next(200, Response(numberOfResponses: 2, milliseconds: 0)),
            Recorded.next(300, Response(numberOfResponses: 3, milliseconds: 0)),
            Recorded.next(400, Response(numberOfResponses: 4, milliseconds: 0)),
            Recorded.next(500, Response(numberOfResponses: 5, milliseconds: 0)),
            Recorded.next(600, Response(numberOfResponses: 6, milliseconds: 0)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: [Observable<Consequence>] = Conc(FR(2), FR(3))
            .transform(testObservable.asObservable(), testObservable.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable[0]
                .map { $0.isReinforcement }
                .subscribe(observerFirst)
                .disposed(by: disposeBag)
            consequenceObservable[1]
                .map { $0.isReinforcement }
                .subscribe(observerSecond)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEventsFirst: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(200, true),
            Recorded.next(300, false),
            Recorded.next(400, true),
            Recorded.next(500, false),
            Recorded.next(600, true),
            Recorded.completed(completedTime)
        ]
        let expectedEventsSecond: [Recorded<Event<Bool>>] = [
            Recorded.next(100, false),
            Recorded.next(200, false),
            Recorded.next(300, true),
            Recorded.next(400, false),
            Recorded.next(500, false),
            Recorded.next(600, true),
            Recorded.completed(completedTime)
        ]
        XCTAssertEqual(observerFirst.events, expectedEventsFirst)
        XCTAssertEqual(observerSecond.events, expectedEventsSecond)

        let expectedSubscriptions = [
            Subscription(startTime, completedTime),
            Subscription(startTime, completedTime)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
