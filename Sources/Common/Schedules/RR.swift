//
//  RR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public extension Single where E == ResponseEntity {

    /// Random ratio schedule
    /// - Complexity: O(1)
    func RR(_ value: Int) -> Single<Bool> {
        return FR(value)
    }

    /// Random ratio schedule
    /// - Complexity: O(1)
    func RR(_ value: Single<Int>) -> Single<Bool> {
        return FR(value)
    }

    /// Random ratio schedule
    /// - Complexity: O(1)
    func RR(value: @escaping () -> Int) -> Single<Bool> {
        return FR(value)
    }

    /// Random ratio schedule
    /// - Complexity: O(1)
    func RR(value: @escaping () -> Single<Int>) -> Single<Bool> {
        return FR(value)
    }
}
