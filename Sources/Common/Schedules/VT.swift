//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Variable time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func variableTime(_ value: TimeInterval, iterations: Int = 12) -> Observable<Consequence> {
        let values: [Milliseconds] = nextVariables(value, iterations: iterations)
        return variableTime(values)
    }

    /// Variable time schedule
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func variableTime(_ values: [Milliseconds]) -> Observable<Consequence> {
        var index: Int = 0
        var lastReinforcementValue: Response = Response.zero

        return map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.milliseconds >= values[index]
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

/// Variable time schedule
///
/// - Parameter value: Reinforcement value
public typealias VT = VariableTime

/// Variable time schedule
///
/// - Parameter value: Reinforcement value
public struct VariableTime: ReinforcementScheduleType {
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
            .variableTime(values)
    }
}
