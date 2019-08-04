//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Fixed time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func fixedTime(_ value: TimeInterval) -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.milliseconds >= value.milliseconds
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
        }
    }
}

/// Fixed time schedule
///
/// - Parameter value: Reinforcement value
public typealias FT = FixedTime

/// Fixed time schedule
///
/// - Parameter value: Reinforcement value
public struct FixedTime: ReinforcementScheduleType {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .fixedTime(value)
    }
}
