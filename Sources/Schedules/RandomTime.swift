//
//  RandomTime.swift
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
public final class RandomTime: ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    private let value: TimeInterval
    private var currentRandom: SessionTime

    public init(_ value: TimeInterval) {
        self.value = value
        self.currentRandom = SessionTime(nextRandom(value))
    }

    public convenience init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastEventValue
        let isReinforcement: Bool = current.sessionTime >= currentRandom
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastEvent(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            currentRandom = SessionTime(nextRandom(value))
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
