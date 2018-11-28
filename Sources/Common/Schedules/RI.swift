//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public extension Single where E == ResponseEntity {

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .RI()
    func RI(_ value: Milliseconds) -> Single<Bool> {
        return FI(value)
    }

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .RI()
    func RI(_ value: Single<Int>) -> Single<Bool> {
        return FI(value)
    }

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .RI()
    func RI(_ value: @escaping () -> Milliseconds) -> Single<Bool> {
        return FI(value)
    }

    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .RI()
    func RI(_ value: @escaping () -> Single<Milliseconds>) -> Single<Bool> {
        return FI(value())
    }
}
