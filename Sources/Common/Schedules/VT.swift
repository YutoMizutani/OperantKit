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
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VT()
    func VT(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return FT(value())
    }

    /// Variable time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VT()
    func VT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return FT(value)
    }
}
