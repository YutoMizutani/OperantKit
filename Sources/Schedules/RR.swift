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
        return RR(value).transform(asResponse())
    }
}

/// Random ratio schedule
///
/// - Parameter value: Reinforcement value
public typealias RR = RandomRatio

/// Random ratio schedule
///
/// - Parameter value: Reinforcement value
public final class RandomRatio: ResponseStoreableReinforcementSchedule {
    public var lastReinforcementValue: Response = .zero

    private let value: Int
    private var currentRandom: Int

    public init(_ value: Int) {
        self.value = value
        currentRandom = nextRandom(value)
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastReinforcementValue
        let isReinforcement: Bool = current.numberOfResponses > 0 && current.numberOfResponses >= currentRandom
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastReinforcement(_ consequence: Consequence) -> Consequence {
        func update(_ response: ResponseCompatible) {
            currentRandom = nextRandom(value)
            lastReinforcementValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }

        return consequence
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = source.map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome.map { [unowned self] in self.updateLastReinforcement($0) }
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
