//
//  DiscreteTrialEndedByTimeScheduleTests.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import RxSwift
import RxTest
import XCTest
@testable import OperantKit

final class DiscreteTrialEndedByTimeScheduleTests: XCTestCase {
    func testStructTrialTime() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable: TestableObservable<Response> = scheduler.createHotObservable([
            Recorded.next(1000, Response(numberOfResponses: 5, milliseconds: 1000)),
            Recorded.next(2000, Response(numberOfResponses: 7, milliseconds: 2000)),
            Recorded.next(3000, Response(numberOfResponses: 10, milliseconds: 3000)),
            Recorded.next(4000, Response(numberOfResponses: 10, milliseconds: 4000)),
            Recorded.next(5000, Response(numberOfResponses: 1000, milliseconds: 5000)),
            Recorded.next(6000, Response(numberOfResponses: 1001, milliseconds: 6000)),
            Recorded.completed(completedTime)
            ])

        let consequenceObservable: Observable<Consequence> = FR(5)
            .trialTime(1, numberOfTrials: 3)
            .transform(testObservable.asObservable())

        scheduler.scheduleAt(startTime) {
            consequenceObservable
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(1000, true),
            Recorded.next(2000, false),
            Recorded.next(3000, true),
            Recorded.completed(3000)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, 3000)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }

    func testMethodChainTrialTime() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        let startTime: TestTime = 0
        let completedTime: TestTime = 10000
        let disposeBag = DisposeBag()

        let testObservable = scheduler.createHotObservable([
            Recorded.next(1000, Response(numberOfResponses: 5, milliseconds: 1000)),
            Recorded.next(2000, Response(numberOfResponses: 7, milliseconds: 2000)),
            Recorded.next(3000, Response(numberOfResponses: 10, milliseconds: 3000)),
            Recorded.next(4000, Response(numberOfResponses: 10, milliseconds: 4000)),
            Recorded.next(5000, Response(numberOfResponses: 1000, milliseconds: 5000)),
            Recorded.next(6000, Response(numberOfResponses: 1001, milliseconds: 6000)),
            Recorded.completed(completedTime)
            ])

        scheduler.scheduleAt(startTime) {
            testObservable
                .fixedRatio(5)
                .trialTime(1, numberOfTrials: 3)
                .map { $0.isReinforcement }
                .subscribe(observer)
                .disposed(by: disposeBag)
        }
        scheduler.start()

        let expectedEvents = [
            Recorded.next(1000, true),
            Recorded.next(2000, false),
            Recorded.next(3000, true),
            Recorded.completed(3000)
        ]
        XCTAssertEqual(observer.events, expectedEvents)

        let expectedSubscriptions = [
            Subscription(startTime, 3000)
        ]
        XCTAssertEqual(testObservable.subscriptions, expectedSubscriptions)
    }
}
