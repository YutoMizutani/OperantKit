//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func fixedTime(_ value: TimeInterval) -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.milliseconds >= value.milliseconds
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
            }
    }
}

// TODO: Remove

extension ResponseEntity {

    /// Fixed time schedule
    ///
    /// - Tag: .fixedTime()
    func fixedTime(_ value: Milliseconds) -> Bool {
        return milliseconds >= value
    }
}

public extension Single where Element == ResponseEntity {

    /// Fixed time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FT()
    func FT(_ value: @escaping @autoclosure () -> Milliseconds) -> Single<Bool> {
        return map { r in r.fixedTime(value()) }
    }

    /// Fixed time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FT()
    func FT(_ value: Single<Int>) -> Single<Bool> {
        return flatMap { r in value.map { v in r.fixedTime(v) } }
    }
}
