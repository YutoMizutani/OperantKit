//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

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
