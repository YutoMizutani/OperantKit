//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public extension Single where Element == ResponseEntity {

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VI()
    func VI(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return FI(value())
    }

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VI()
    func VI(_ value: Single<Milliseconds>) -> Single<Bool> {
        return FI(value)
    }
}
