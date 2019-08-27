//
//  SessionResponse.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/27.
//

import RxSwift

public extension ReinforcementSchedule {
    /// Free operant procedure with trial response
    ///
    /// - Complexity: O(1)
    func sessionResponse(_ value: Int, numberOfSessions: Int = 1) -> FreeOperant {
        return sessions(by: .response(value), numberOfSessions: numberOfSessions)
    }
}

public extension ObservableType where Element == Consequence {
    /// Free operant procedure with trial response
    ///
    /// - Complexity: O(1)
    func sessionResponse(_ value: Int, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessions(by: .response(value), numberOfSessions: numberOfSessions)
    }
}

/// Session response
///
/// - Complexity: O(1)
public struct SessionResponseCondition: FreeOperantCondition {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func condition(_ consequence: Consequence, lastSessionValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastSessionValue
        return current.numberOfResponses >= value
    }
}
