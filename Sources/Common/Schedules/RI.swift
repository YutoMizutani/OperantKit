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
    func randomInterval(_ value: TimeInterval) -> Observable<Consequence> {
        var nextValue: Milliseconds = nextRandom(value)
        var lastReinforcementValue: Response = Response.zero

        return asObservable()
            .map {
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

// TODO: Remove

public extension Single where Element == ResponseEntity {

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RI()
    func RI(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return FI(value())
    }

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RI()
    func RI(_ value: Single<Milliseconds>) -> Single<Bool> {
        return FI(value)
    }
}
