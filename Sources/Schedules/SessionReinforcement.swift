//
//  SessionReinforcement.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/25.
//

import RxRelay
import RxSwift

public extension ReinforcementSchedule {
    /// Reinforcement schedule with session reinforcement
    ///
    /// - Complexity: O(1)
    func sessionReinforcement(_ numberOfReinforcement: Int) -> SessionReinforcement {
        return SessionReinforcement(schedule: self, numberOfReinforcement: numberOfReinforcement)
    }
}

public extension ObservableType where Element == Consequence {
    /// Reinforcement schedule with session reinforcement
    ///
    /// - Complexity: O(1)
    func sessionReinforcement(_ numberOfReinforcement: Int) -> Observable<Consequence> {
        return SessionReinforcement(numberOfReinforcement: numberOfReinforcement)
            .transform(asObservable())
    }
}

/// Reinforcement schedule with session reinforcement
///
/// - important: If the session reinforcement is met, it emits `Observable.completed`.
///
/// - Complexity: O(1)
public final class SessionReinforcement: DeinitDisposable, ResponseStoreableReinforcementSchedule {
    public typealias ScheduleType = ReinforcementSchedule

    public var lastReinforcementValue: Response = .zero

    private let schedule: ScheduleType!
    fileprivate let numberOfReinforcement: Int
    fileprivate var currentValue: Int

    public init(schedule: ScheduleType,
                numberOfReinforcement: Int,
                currentValue: Int = 0) {
        self.schedule = schedule
        self.numberOfReinforcement = numberOfReinforcement
        self.currentValue = currentValue
    }

    fileprivate init(numberOfReinforcement: Int,
                     currentValue: Int = 0) {
        self.schedule = nil
        self.numberOfReinforcement = numberOfReinforcement
        self.currentValue = currentValue
    }

    public func updateLastReinforcement(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastReinforcementValue = response.asResponse()
            currentValue += 1
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }
    }

    func sessionReinforcement(_ source: Observable<Consequence>) -> Observable<Consequence> {
        let completableSubject: ReplaySubject<Consequence> = ReplaySubject.create(bufferSize: 1)

        source.materialize()
            .subscribe(onNext: { [unowned self] in
                switch $0 {
                case .next(let e):
                    completableSubject.onNext(e)
                    if self.currentValue >= self.numberOfReinforcement {
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

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = schedule.transform(source)

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { self.updateLastReinforcement($0) })
        }

        return sessionReinforcement(outcome)
            .share(replay: 1, scope: .whileConnected)
    }

    fileprivate func transform(_ outcome: Observable<Consequence>) -> Observable<Consequence> {
        let outcome: Observable<Consequence> = outcome
            .do(onNext: { self.updateLastReinforcement($0) })

        return sessionReinforcement(outcome)
            .share(replay: 1, scope: .whileConnected)
    }
}
