//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

@inline(__always)
private func nextVariables(_ value: Int, iterations: Int) -> [Int] {
    return FleshlerHoffman().generatedRatio(
        value: value,
        iterations: iterations
    )
}

public extension ObservableType where Element: ResponseCompatible {
    func variableRatio(_ value: Int, iterations: Int = 12) -> Observable<Consequence> {
        let values: [Int] = nextVariables(value, iterations: iterations)
        return variableRatio(values)
    }

    func variableRatio(_ values: [Int]) -> Observable<Consequence> {
        var index: Int = 0
        var lastReinforcementValue: Response = Response.zero

        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.numberOfResponses >= values[index]
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

    /// Variable ratio schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VR()
    func VR(_ value: @escaping @autoclosure () -> Int) -> Single<Bool> {
        return FR(value())
    }

    /// Variable ratio schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .VR()
    func VR(_ value: Single<Int>) -> Single<Bool> {
        return FR(value)
    }
}
