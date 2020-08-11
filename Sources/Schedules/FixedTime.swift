//
//  FixedTime.swift
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
public final class FixedTime: ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    private let value: SessionTime

    public init(_ value: TimeInterval) {
        self.value = SessionTime(value.milliseconds)
    }

    public convenience init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastEventValue
        let isReinforcement: Bool = current.sessionTime >= value
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastEvent(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastEventValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = source.map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { [unowned self] in self.updateLastEvent($0) })
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
