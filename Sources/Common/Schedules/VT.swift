//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension Single where Element == ResponseEntity {

    /// Variable time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VT()
    func VT(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return FT(value())
    }

    /// Variable time schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VT()
    func VT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return FT(value)
    }
}
