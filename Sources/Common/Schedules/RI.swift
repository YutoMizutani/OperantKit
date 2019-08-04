//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

@inline(__always)
func nextRandom(_ value: TimeInterval) -> Milliseconds {
    return Milliseconds.random(in: 1...value.milliseconds)
}

public extension ObservableType where Element: ResponseCompatible {
    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func randomInterval(_ value: TimeInterval) -> Observable<Consequence> {
        var nextValue: Milliseconds = nextRandom(value)
        var lastReinforcementValue: Response = Response.zero

        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= nextValue
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

/// Random interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias RI = RandomInterval

/// Random interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public struct RandomInterval: ReinforcementScheduleType {
    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .randomInterval(value)
    }
}
