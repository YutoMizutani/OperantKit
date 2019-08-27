//
//  Trial.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxSwift

public enum TrialType {
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
    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by condition: FinishableCondition, numberOfTrials: Int) -> DiscreteTrial {
        return DiscreteTrial(self,
                             numberOfTrials: numberOfTrials,
                             currentValue: 0,
                             condition: condition)
    }

    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by type: TrialType, numberOfTrials: Int) -> DiscreteTrial {
        return DiscreteTrial(self,
                             numberOfTrials: numberOfTrials,
                             currentValue: 0,
                             condition: type.condition)
    }

    /// Discrete trial procedure with trial time
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: TimeInterval, numberOfTrials: Int) -> DiscreteTrial {
        return trials(by: .time(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial time
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: Seconds, numberOfTrials: Int) -> DiscreteTrial {
        return trialTime(.seconds(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialResponse(_ value: Int, numberOfTrials: Int) -> DiscreteTrial {
        return trials(by: .response(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialReinforcement(_ value: Int, numberOfTrials: Int) -> DiscreteTrial {
        return trials(by: .reinforcement(value), numberOfTrials: numberOfTrials)
    }
}

public extension ObservableType where Element == Consequence {
    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by condition: FinishableCondition, numberOfTrials: Int) -> Observable<Consequence> {
        return DiscreteTrial(numberOfTrials: numberOfTrials, condition: condition)
            .transform(asObservable())
    }

    /// Discrete trial procedure
    ///
    /// - Complexity: O(1)
    func trials(by type: TrialType, numberOfTrials: Int) -> Observable<Consequence> {
        return DiscreteTrial(numberOfTrials: numberOfTrials, condition: type.condition)
            .transform(asObservable())
    }

    /// Discrete trial procedure with trial time
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: TimeInterval, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .time(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial time
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: Seconds, numberOfTrials: Int) -> Observable<Consequence> {
        return trialTime(.seconds(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialResponse(_ value: Int, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .response(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial reinforcement
    ///
    /// - Complexity: O(1)
    func trialReinforcement(_ value: Int, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .reinforcement(value), numberOfTrials: numberOfTrials)
    }
}

/// Discrete trial procedure
///
/// - important: If the trial is finished, it emits `Observable.completed`.
///
/// - Complexity: O(1)
public final class DiscreteTrial: DeinitDisposable, ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    public typealias ScheduleType = ReinforcementSchedule

    public let schedule: ScheduleType!
    public let numberOfTrials: Int
    public let condition: FinishableCondition

    private var currentValue: Int

    public init(_ schedule: ScheduleType,
                numberOfTrials: Int,
                currentValue: Int = 0,
                condition: FinishableCondition) {
        self.schedule = schedule
        self.numberOfTrials = numberOfTrials
        self.currentValue = currentValue
        self.condition = condition
    }

    fileprivate init(numberOfTrials: Int,
                     currentValue: Int = 0,
                     condition: FinishableCondition) {
        self.schedule = nil
        self.numberOfTrials = numberOfTrials
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

    public func updateLastEvent(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            (schedule as? LastEventComparable)?.updateLastEvent(consequence)
            lastEventValue = response.asResponse()
            currentValue += 1
        }

        if condition.canFinish(consequence, lastEventValue: lastEventValue) {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = schedule.transform(source, isAutoUpdateReinforcementValue: false)

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { self.updateLastEvent($0) })
        }

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }

    fileprivate func transform(_ outcome: Observable<Consequence>) -> Observable<Consequence> {
        let outcome: Observable<Consequence> = outcome
            .do(onNext: { self.updateLastEvent($0) })

        return completeMap(outcome)
            .share(replay: 1, scope: .whileConnected)
    }
}
