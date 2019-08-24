//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Random time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func randomTime(_ value: TimeInterval) -> Observable<Consequence> {
        return RT(value).transform(asResponse())
    }
}

/// Random time schedule
///
/// - Parameter value: Reinforcement value
public typealias RT = RandomTime

/// Random time schedule
///
/// - Parameter value: Reinforcement value
public final class RandomTime: ResponseStoreableReinforcementSchedule {
    public var lastReinforcementValue: Response = .zero

    private let value: TimeInterval
    private var currentRandom: Milliseconds

    public init(_ value: TimeInterval) {
        self.value = value
        self.currentRandom = nextRandom(value)
    }

    public convenience init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastReinforcementValue
        let isReinforcement: Bool = current.milliseconds >= currentRandom
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
