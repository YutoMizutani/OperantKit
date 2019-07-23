//
//  RR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

@inline(__always)
private func nextRandom(_ value: Int) -> Int {
    return Int.random(in: 1...value)
}

public extension ObservableType where Element: ResponseCompatible {
    /// Random ratio schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func randomRatio(_ value: Int) -> Observable<Consequence> {
        var nextValue: Int = nextRandom(value)
        var lastReinforcementValue: Response = Response.zero

        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.numberOfResponses >= nextValue
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    nextValue = nextRandom(value)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
            }
    }
}

/// Random ratio schedule
///
/// - Parameter value: Reinforcement value
public struct RR<ResponseType: ResponseCompatible> {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func transform(_ source: Observable<ResponseType>) -> Observable<Consequence> {
        return source.asResponse()
            .randomRatio(value)
    }
}
