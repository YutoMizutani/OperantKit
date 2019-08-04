//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func fixedInterval(_ value: TimeInterval) -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= value.milliseconds
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
        }
    }
}

/// Fixed interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias FI = FixedInterval

/// Fixed interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public struct FixedInterval: ReinforcementScheduleType {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .fixedInterval(value)
    }
}
