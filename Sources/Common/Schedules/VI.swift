//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

@inline(__always)
func generatedInterval(_ value: TimeInterval, iterations: Int) -> [Milliseconds] {
    return FleshlerHoffman().generatedInterval(
        value: value.milliseconds,
        iterations: iterations
    )
}

public extension ObservableType where Element: ResponseCompatible {
    /// Variable interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func variableInterval(_ value: TimeInterval, iterations: Int = 12) -> Observable<Consequence> {
        return VI(value, iterations: iterations).transform(asResponse())
    }

    /// Variable interval schedule
    ///
    /// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func variableInterval(_ values: [Milliseconds]) -> Observable<Consequence> {
        return VI(values).transform(asResponse())
    }
}

/// Variable interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias VI = VariableInterval

/// Variable interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public final class VariableInterval: ResponseStoreableReinforcementSchedule {
    public var lastReinforcementValue: Response = .zero

    private let values: [Milliseconds]
    private var index: Int = 0

    public init(_ values: [Milliseconds]) {
        self.values = values
    }

    public convenience init(_ value: TimeInterval, iterations: Int = 12) {
        let values: [Milliseconds] = generatedInterval(value, iterations: iterations)
        self.init(values)
    }

    public convenience init(_ value: Seconds, iterations: Int = 12) {
        self.init(TimeInterval.seconds(value), iterations: iterations)
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastReinforcementValue
        let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= values[index]
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastReinforcement(_ consequence: Consequence) -> Consequence {
        func update(_ response: ResponseCompatible) {
            index += 1
            if index >= values.count {
                index = 0
            }
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
