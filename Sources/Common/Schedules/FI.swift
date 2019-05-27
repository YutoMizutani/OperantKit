//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension ResponseEntity {

    /// Fixed interval schedule
    /// - Tag: .fixedInterval()
    func fixedInterval(_ value: Milliseconds, _ previousNumOfResponses: Int) -> Bool {
        return numOfResponses > previousNumOfResponses
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
            .map { $0.newValue.fixedInterval(value(), $0.oldValue.numOfResponses) }
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
                    a.newValue.fixedInterval(b, a.oldValue.numOfResponses)
                }
            }
    }
}
