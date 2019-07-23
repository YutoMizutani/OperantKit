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
    /// Variable ratio schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
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

/// Variable ratio schedule
///
/// - Parameter value: Reinforcement value
public struct VR<ResponseType: ResponseCompatible> {
    private let value: Int
    private let iterations: Int

    public init(_ value: Int, iterations: Int = 12) {
        self.value = value
        self.iterations = iterations
    }

    public func transform(_ source: Observable<ResponseType>) -> Observable<Consequence> {
        return source.asResponse()
            .variableRatio(value, iterations: iterations)
    }
}
