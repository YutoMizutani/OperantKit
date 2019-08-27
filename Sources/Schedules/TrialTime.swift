//
//  TrialTime.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxSwift

public extension ReinforcementSchedule {
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
}

public extension ObservableType where Element == Consequence {
    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: TimeInterval, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .time(value), numberOfTrials: numberOfTrials)
    }

    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialTime(_ value: Seconds, numberOfTrials: Int) -> Observable<Consequence> {
        return trialTime(.seconds(value), numberOfTrials: numberOfTrials)
    }
}

/// Trial time
///
/// - Complexity: O(1)
public struct TrialTimeCondition: DiscreteTrialCondition {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public func condition(_ consequence: Consequence, lastTrialValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastTrialValue
        return current.milliseconds >= value.milliseconds
    }
}
