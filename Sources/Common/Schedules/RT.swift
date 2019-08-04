//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Random time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func randomTime(_ value: TimeInterval) -> Observable<Consequence> {
        var nextValue: Milliseconds = nextRandom(value)
        var lastReinforcementValue: Response = Response.zero

        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.milliseconds >= nextValue
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    nextValue = nextRandom(value)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
        }
    }
}

/// Random time schedule
///
/// - Parameter value: Reinforcement value
public typealias RT = RandomTime

/// Random time schedule
///
/// - Parameter value: Reinforcement value
public struct RandomTime: ReinforcementScheduleType {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .randomTime(value)
    }
}
