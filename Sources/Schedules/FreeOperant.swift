//
//  ContinuousFreeOperant.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import Foundation

import RxSwift

public protocol FreeOperantCondition {
    func condition(_ consequence: Consequence, lastSessionValue: Response) -> Bool
}

public enum SessionType {
    case time(TimeInterval)
    case response(Int)
    case reinforcement(Int)

    var condition: FreeOperantCondition {
        switch self {
        case .time(let v):
            return SessionTimeCondition(v)
        case .response(let v):
            return SessionResponseCondition(v)
        case .reinforcement(let v):
            return SessionReinforcementCondition(v)
        }
    }
}

public extension ReinforcementSchedule {
    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by type: SessionType, numberOfSessions: Int) -> FreeOperant {
        return FreeOperant(self,
                           numberOfSessions: numberOfSessions,
                           currentValue: 0,
                           sessionType: type)
    }
}

public extension ObservableType where Element == Consequence {
    /// Free operant procedure
    ///
    /// - Complexity: O(1)
    func sessions(by type: SessionType, numberOfSessions: Int) -> Observable<Consequence> {
        return FreeOperant(numberOfSessions: numberOfSessions, sessionType: type)
            .transform(asObservable())
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
    public let condition: FreeOperantCondition

    private var currentValue: Int

    public init(_ schedule: ScheduleType,
                numberOfSessions: Int = 1,
                currentValue: Int = 0,
                sessionType: SessionType) {
        self.schedule = schedule
        self.numberOfSessions = numberOfSessions
        self.currentValue = currentValue
        self.condition = sessionType.condition
    }

    fileprivate init(numberOfSessions: Int = 1,
                     currentValue: Int = 0,
                     sessionType: SessionType) {
        self.schedule = nil
        self.numberOfSessions = numberOfSessions
        self.currentValue = currentValue
        self.condition = sessionType.condition
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

        if condition.condition(consequence, lastSessionValue: lastSessionValue) {
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
