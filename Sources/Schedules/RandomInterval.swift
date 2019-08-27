//
//  RandomInterval.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

@inline(__always)
func nextRandom(_ value: TimeInterval) -> Milliseconds {
    return Milliseconds.random(in: 1...value.milliseconds)
}

public extension ObservableType where Element: ResponseCompatible {
    /// Random interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func randomInterval(_ value: TimeInterval) -> Observable<Consequence> {
        return RI(value).transform(asResponse())
    }
}

/// Random interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias RI = RandomInterval

/// Random interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public final class RandomInterval: ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    private let value: TimeInterval
    private var currentRandom: Milliseconds

    public init(_ value: TimeInterval) {
        self.value = value
        currentRandom = nextRandom(value)
    }

    public convenience init(_ value: Seconds) {
        self.init(TimeInterval.seconds(value))
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastEventValue
        let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= currentRandom
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastEvent(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            currentRandom = nextRandom(value)
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
