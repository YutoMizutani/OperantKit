//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension Single where E == ResponseEntity {

    /// Variable ratio schedule
    /// - Complexity: O(1)
    func VR(_ value: Int) -> Single<Bool> {
        return FR(value)
    }

    /// Variable ratio schedule
    /// - Complexity: O(1)
    func VR(_ value: Single<Int>) -> Single<Bool> {
        return FR(value)
    }

    /// Variable ratio schedule
    /// - Complexity: O(1)
    func VR(_ value: @escaping () -> Int) -> Single<Bool> {
        return FR(value)
    }

    /// Variable ratio schedule
    /// - Complexity: O(1)
    func VR(_ value: @escaping () -> Single<Int>) -> Single<Bool> {
        return FR(value)
    }
}
