//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Fixed time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func fixedTime(_ value: TimeInterval) -> Observable<Consequence> {
        return FT(value).transform(asResponse())
    }
}

/// Fixed time schedule
///
/// - Parameter value: Reinforcement value
public typealias FT = FixedTime

/// Fixed time schedule
///
/// - Parameter value: Reinforcement value
public final class FixedTime: ResponseStoreableReinforcementSchedule {
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
        let isReinforcement: Bool = current.milliseconds >= value.milliseconds
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastReinforcement(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastReinforcementValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = source.map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { [unowned self] in self.updateLastReinforcement($0) })
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
