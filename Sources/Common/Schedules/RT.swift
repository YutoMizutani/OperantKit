//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension Single where E == ResponseEntity {

    /// Random time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: Milliseconds) -> Single<Bool> {
        return FT(value)
    }

    /// Random time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: Single<Int>) -> Single<Bool> {
        return FT(value)
    }

    /// Random time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: @escaping () -> Milliseconds) -> Single<Bool> {
        return FT(value)
    }

    /// Random time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .RT()
    func RT(_ value: @escaping () -> Single<Milliseconds>) -> Single<Bool> {
        return FT(value)
    }
}
