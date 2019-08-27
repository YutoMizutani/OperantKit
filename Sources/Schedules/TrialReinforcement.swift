//
//  TrialReinforcement.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import RxSwift

public extension ReinforcementSchedule {
    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialReinforcement(_ value: Int, numberOfTrials: Int) -> DiscreteTrial {
        return trials(by: .reinforcement(value), numberOfTrials: numberOfTrials)
    }
}

public extension ObservableType where Element == Consequence {
    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialReinforcement(_ value: Int, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .reinforcement(value), numberOfTrials: numberOfTrials)
    }
}

/// Trial reinforcement
///
/// - Complexity: O(1)
public final class TrialReinforcementCondition: DiscreteTrialCondition {
    private let value: Int

    private var currentValue: Int

    public init(_ value: Int,
                currentValue: Int = 0) {
        self.value = value
        self.currentValue = currentValue
    }

    public func condition(_ consequence: Consequence, lastTrialValue: Response) -> Bool {
        if consequence.isReinforcement {
            currentValue += 1
        }

        let result = currentValue >= value

        // Reset current value
        if result {
            currentValue = 0
        }

        return result
    }
}
