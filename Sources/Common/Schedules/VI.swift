//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

@inline(__always)
func nextVariables(_ value: TimeInterval, iterations: Int) -> [Milliseconds] {
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
        let values: [Milliseconds] = nextVariables(value, iterations: iterations)
        return variableInterval(values)
    }

    func variableInterval(_ values: [Milliseconds]) -> Observable<Consequence> {
        var index: Int = 0
        var lastReinforcementValue: Response = Response.zero

        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.milliseconds >= values[index]
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

/// Variable interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public typealias VI = VariableInterval

/// Variable interval schedule
///
/// - important: In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
/// - Parameter value: Reinforcement value
public struct VariableInterval: ReinforcementScheduleType {
    private let values: [Milliseconds]

    public init(_ values: [Milliseconds]) {
        self.values = values
    }

    public init(_ value: TimeInterval, iterations: Int = 12) {
        self.init(nextVariables(value, iterations: iterations))
    }

    public init(_ value: Seconds, iterations: Int = 12) {
        self.init(TimeInterval.seconds(value), iterations: iterations)
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .variableInterval(values)
    }
}
