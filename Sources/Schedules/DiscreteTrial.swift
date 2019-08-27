//
//  Trial.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxSwift

public protocol DiscreteTrialCondition {
    func condition(_ consequence: Consequence, lastTrialValue: Response) -> Bool
}

public enum TrialType {
    case time(TimeInterval)
    case response(Int)
    case reinforcement(Int)

    var condition: DiscreteTrialCondition {
        switch self {
        case .time(let v):
            return TrialTimeCondition(v)
        case .response(let v):
            return TrialResponseCondition(v)
        case .reinforcement(let v):
            return TrialReinforcementCondition(v)
        }
    }
}

public extension ReinforcementSchedule {
    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by type: TrialType, numberOfTrials: Int) -> DiscreteTrial {
        return DiscreteTrial(self,
                             numberOfTrials: numberOfTrials,
                             currentValue: 0,
                             trialType: type)
    }
}

public extension ObservableType where Element == Consequence {
    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by type: TrialType, numberOfTrials: Int) -> Observable<Consequence> {
        return DiscreteTrial(numberOfTrials: numberOfTrials, trialType: type)
            .transform(asObservable())
    }
}

/// Discrete trial procedure
///
/// - important: If the trial is finished, it emits `Observable.completed`.
///
/// - Complexity: O(1)
public final class DiscreteTrial: DeinitDisposable, TrialStoreableReinforcementSchedule {
    public var lastTrialValue: Response = .zero

    public typealias ScheduleType = ReinforcementSchedule

    public let schedule: ScheduleType!
    public let numberOfTrials: Int
    public let condition: DiscreteTrialCondition

    private var currentValue: Int

    public init(_ schedule: ScheduleType,
                numberOfTrials: Int,
                currentValue: Int = 0,
                trialType: TrialType) {
        self.schedule = schedule
        self.numberOfTrials = numberOfTrials
        self.currentValue = currentValue
        self.condition = trialType.condition
    }

    fileprivate init(numberOfTrials: Int,
                     currentValue: Int = 0,
                     trialType: TrialType) {
        self.schedule = nil
        self.numberOfTrials = numberOfTrials
        self.currentValue = currentValue
        self.condition = trialType.condition
    }

    func completeMap(_ source: Observable<Consequence>) -> Observable<Consequence> {
        let completableSubject: ReplaySubject<Consequence> = ReplaySubject.create(bufferSize: 1)

        source.materialize()
            .subscribe(onNext: { [unowned self] in
                switch $0 {
                case .next(let e):
                    completableSubject.onNext(e)
                    if self.currentValue >= self.numberOfTrials {
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

    public func updateLastTrial(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastTrialValue = response.asResponse()
            currentValue += 1
        }

        if condition.condition(consequence, lastTrialValue: lastTrialValue) {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = schedule.transform(source)

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { self.updateLastTrial($0) })
        }

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }

    fileprivate func transform(_ outcome: Observable<Consequence>) -> Observable<Consequence> {
        let outcome: Observable<Consequence> = outcome
            .do(onNext: { self.updateLastTrial($0) })

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }
}
