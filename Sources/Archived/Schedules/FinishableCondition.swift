//
//  FinishableCondition.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import Foundation

public protocol FinishableCondition {
    func canFinish(_ consequence: Consequence, lastEventValue: Response) -> Bool
}

/// Finish by response
///
/// - Complexity: O(1)
public struct FinishByResponse: FinishableCondition {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func canFinish(_ consequence: Consequence, lastEventValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastEventValue
        return current.numberOfResponses >= value
    }
}

/// Finish by time
///
/// - Complexity: O(1)
public struct FinishByTime: FinishableCondition {
    private let value: SessionTime

    public init(_ value: TimeInterval) {
        self.value = SessionTime(value.milliseconds)
    }

    public func canFinish(_ consequence: Consequence, lastEventValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastEventValue
        return current.sessionTime >= value
    }
}

/// Finish by reinforcement
///
/// - Complexity: O(1)
public final class FinishByReinforcement: FinishableCondition {
    private let value: Int

    private var currentValue: Int

    public init(_ value: Int,
                currentValue: Int = 0) {
        self.value = value
        self.currentValue = currentValue
    }

    public func canFinish(_ consequence: Consequence, lastEventValue: Response) -> Bool {
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
