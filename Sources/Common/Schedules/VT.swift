//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func variableTime(_ value: TimeInterval, iterations: Int = 12) -> Observable<Consequence> {
        let values: [Milliseconds] = nextVariables(value, iterations: iterations)
        return variableTime(values)
    }

    func variableTime(_ values: [Milliseconds]) -> Observable<Consequence> {
        var index: Int = 0
        var lastReinforcementValue: Response = Response.zero

        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.milliseconds >= values[index]
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    index += 1
                    if index >= values.count {
                        index = 0
                    }
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
            }
    }
}

// TODO: Remove

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
