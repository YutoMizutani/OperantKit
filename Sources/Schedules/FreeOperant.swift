//
//  ContinuousFreeOperant.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import Foundation

import RxSwift

public enum SessionType {
    case time(TimeInterval)
    case response(Int)
    case reinforcement(Int)

    var condition: FinishableCondition {
        switch self {
        case .time(let v):
            return FinishByTime(v)
        case .response(let v):
            return FinishByResponse(v)
        case .reinforcement(let v):
            return FinishByReinforcement(v)
        }
    }
}

public extension ReinforcementSchedule {
    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by condition: FinishableCondition, numberOfSessions: Int) -> FreeOperant {
        return FreeOperant(self,
                           numberOfSessions: numberOfSessions,
                           currentValue: 0,
                           condition: condition)
    }

    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by type: SessionType, numberOfSessions: Int) -> FreeOperant {
        return FreeOperant(self,
                           numberOfSessions: numberOfSessions,
                           currentValue: 0,
                           condition: type.condition)
    }

    /// Free operant procedure with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: TimeInterval, numberOfSessions: Int = 1) -> FreeOperant {
        return sessions(by: .time(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: Seconds, numberOfSessions: Int = 1) -> FreeOperant {
        return sessionTime(.seconds(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session response
    ///
    /// - Complexity: O(1)
    func sessionResponse(_ value: Int, numberOfSessions: Int = 1) -> FreeOperant {
        return sessions(by: .response(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session reinforcement
    ///
    /// - Complexity: O(1)
    func sessionReinforcement(_ value: Int, numberOfSessions: Int = 1) -> FreeOperant {
        return sessions(by: .reinforcement(value), numberOfSessions: numberOfSessions)
    }
}

public extension ObservableType where Element == Consequence {
    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by condition: FinishableCondition, numberOfSessions: Int) -> Observable<Consequence> {
        return FreeOperant(numberOfSessions: numberOfSessions, condition: condition)
            .transform(asObservable())
    }

    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by type: SessionType, numberOfSessions: Int) -> Observable<Consequence> {
        return FreeOperant(numberOfSessions: numberOfSessions, condition: type.condition)
            .transform(asObservable())
    }

    /// Free operant procedure with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: TimeInterval, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessions(by: .time(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: Seconds, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessionTime(.seconds(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session response
    ///
    /// - Complexity: O(1)
    func sessionResponse(_ value: Int, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessions(by: .response(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session reinforcement
    ///
    /// - Complexity: O(1)
    func sessionReinforcement(_ value: Int, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessions(by: .reinforcement(value), numberOfSessions: numberOfSessions)
    }
}

/// Free operant procedure
///
/// - important: If the session is finished, it emits `Observable.completed`.
///
/// - Complexity: O(1)
public final class FreeOperant: DeinitDisposable, SessionStoreableReinforcementSchedule {
    public var lastSessionValue: Response = .zero

    public typealias ScheduleType = ReinforcementSchedule

    public let schedule: ScheduleType!
    public let numberOfSessions: Int
    public let condition: FinishableCondition

    private var currentValue: Int

    public init(_ schedule: ScheduleType,
                numberOfSessions: Int = 1,
                currentValue: Int = 0,
                condition: FinishableCondition) {
        self.schedule = schedule
        self.numberOfSessions = numberOfSessions
        self.currentValue = currentValue
        self.condition = condition
    }

    fileprivate init(numberOfSessions: Int = 1,
                     currentValue: Int = 0,
                     condition: FinishableCondition) {
        self.schedule = nil
        self.numberOfSessions = numberOfSessions
        self.currentValue = currentValue
        self.condition = condition
    }

    func completeMap(_ source: Observable<Consequence>) -> Observable<Consequence> {
        let completableSubject: ReplaySubject<Consequence> = ReplaySubject.create(bufferSize: 1)

        source.materialize()
            .subscribe(onNext: { [unowned self] in
                switch $0 {
                case .next(let e):
                    completableSubject.onNext(e)
                    if self.currentValue >= self.numberOfSessions {
                        completableSubject.onCompleted()
                        completableSubject.dispose()
                        self.compositeDisposable.dispose()
                    }
                case .error(let e):
                    completableSubject.onError(e)
                    completableSubject.dispose()
                    self.compositeDisposable.dispose()
                case .completed:
                    completableSubject.onCompleted()
                    completableSubject.dispose()
                    self.compositeDisposable.dispose()
                }
            })
            .disposed(by: compositeDisposable)

        return completableSubject.asObservable()
    }

    public func updateLastSession(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastSessionValue = response.asResponse()
            currentValue += 1
        }

        if condition.canFinish(consequence, lastValue: lastSessionValue) {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = schedule.transform(source)

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { self.updateLastSession($0) })
        }

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }

    fileprivate func transform(_ outcome: Observable<Consequence>) -> Observable<Consequence> {
        let outcome: Observable<Consequence> = outcome
            .do(onNext: { self.updateLastSession($0) })

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }
}
