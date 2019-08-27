//
//  TrialResponse.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxSwift

public extension ReinforcementSchedule {
    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialResponse(_ value: Int, numberOfTrials: Int) -> DiscreteTrial {
        return trials(by: .response(value), numberOfTrials: numberOfTrials)
    }
}

public extension ObservableType where Element == Consequence {
    /// Discrete trial procedure with trial response
    ///
    /// - Complexity: O(1)
    func trialResponse(_ value: Int, numberOfTrials: Int) -> Observable<Consequence> {
        return trials(by: .response(value), numberOfTrials: numberOfTrials)
    }
}

/// Trial response
///
/// - Complexity: O(1)
public struct TrialResponseCondition: DiscreteTrialCondition {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func condition(_ consequence: Consequence, lastTrialValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastTrialValue
        return current.numberOfResponses >= value
    }
}
