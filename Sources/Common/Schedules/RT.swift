//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func randomTime(_ value: TimeInterval) -> Observable<Consequence> {
        var nextValue: Milliseconds = nextRandom(value)
        var lastReinforcementValue: Response = Response.zero

        return asObservable()
            .map {
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

// TODO: Remove

public extension Single where Element == ResponseEntity {

    /// Random time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return FT(value())
    }

    /// Random time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return FT(value)
    }
}
