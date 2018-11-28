//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension ResponseEntity {

    /// Fixed interval schedule
    func fixedInterval(_ value: Milliseconds, _ previousNumOfResponses: Int) -> Bool {
        return numOfResponses > previousNumOfResponses
            && fixedTime(value)
    }
}

public extension Single where E == ResponseEntity {

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .FI()
    func FI(_ value: Milliseconds) -> Single<Bool> {
        return store(startWith: ResponseEntity())
            .map { $0.newValue.fixedInterval(value, $0.oldValue.numOfResponses) }
    }

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .FI()
    func FI(_ value: Single<Int>) -> Single<Bool> {
        return store(startWith: ResponseEntity())
            .flatMap { a in
                value.map { b in
                    a.newValue.fixedInterval(b, a.oldValue.numOfResponses)
                }
            }
    }

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .FI()
    func FI(_ value: @escaping () -> Milliseconds) -> Single<Bool> {
        return store(startWith: ResponseEntity())
            .map { $0.newValue.fixedInterval(value(), $0.oldValue.numOfResponses) }
    }

    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Tag: .FI()
    func FI(_ value: @escaping () -> Single<Milliseconds>) -> Single<Bool> {
        return store(startWith: ResponseEntity())
            .flatMap { a in
                value().map { v in
                    a.newValue.fixedInterval(v, a.oldValue.numOfResponses)
                }
            }
    }
}
