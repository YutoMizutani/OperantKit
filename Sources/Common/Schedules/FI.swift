//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func fixedInterval(_ value: TimeInterval) -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return asObservable()
            .map {
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

// TODO: Remove

extension ResponseEntity {

    /// Fixed interval schedule
    /// - Tag: .fixedInterval()
    func fixedInterval(_ value: Milliseconds, _ previousnumberOfResponses: Int) -> Bool {
        return numberOfResponses > previousnumberOfResponses
            && fixedTime(value)
    }
}

public extension Single where Element == ResponseEntity {

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FI()
    func FI(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return store(startWith: ResponseEntity.zero)
            .map { $0.newValue.fixedInterval(value(), $0.oldValue.numberOfResponses) }
    }

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FI()
    func FI(_ value: Single<Int>) -> Single<Bool> {
        return store(startWith: ResponseEntity.zero)
            .flatMap { a in
                value.map { b in
                    a.newValue.fixedInterval(b, a.oldValue.numberOfResponses)
                }
            }
    }
}
