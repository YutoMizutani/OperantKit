//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Fixed interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func fixedInterval(_ value: TimeInterval) -> Observable<Consequence> {
        return FI(value).transform(asResponse())
    }
}

/// Fixed interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias FI = FixedInterval

/// Fixed interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public final class FixedInterval: ResponseStoreableReinforcementSchedule {
    public var lastReinforcementValue: Response = .zero

    private let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }

    public convenience init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastReinforcementValue
        let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= value.milliseconds
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastReinforcement(_ consequence: Consequence) -> Consequence {
        func update(_ response: ResponseCompatible) {
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
