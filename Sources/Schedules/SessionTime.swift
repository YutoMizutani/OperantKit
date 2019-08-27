//
//  SessionTime.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2019/07/25.
//

import RxSwift

public extension ReinforcementSchedule {
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
}

public extension ObservableType where Element == Consequence {
    /// Free operant procedure with session response
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: TimeInterval, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessions(by: .time(value), numberOfSessions: numberOfSessions)
    }

    /// Free operant procedure with session response
    ///
    /// - Complexity: O(1)
    func sessionTime(_ value: Seconds, numberOfSessions: Int = 1) -> Observable<Consequence> {
        return sessionTime(.seconds(value), numberOfSessions: numberOfSessions)
    }
}

/// Session time
///
/// - Complexity: O(1)
public struct SessionTimeCondition: FreeOperantCondition {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public func condition(_ consequence: Consequence, lastSessionValue: Response) -> Bool {
        let current: Response = consequence.response.asResponse() - lastSessionValue
        return current.milliseconds >= value.milliseconds
    }
}
