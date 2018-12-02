//
//  Parameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/12/01.
//

import Foundation

public enum Parameter {
    case fixed(value: Int)
    case variable(value: Int, values: [Int], order: Int)
    case random(value: Int, current: Int)
    case empty

    public init(_ value: Int, values: [Int] = []) {
        if values.isEmpty {
            self = .fixed(value: value)
        } else {
            self = .variable(value: value, values: values, order: 0)
        }
    }

    public init(_ value: Int, type: ParameterType) {
        switch type {
        case .fixed:
            self = .fixed(value: value)
        case .variable:
            self = .variable(value: value,
                             values: FleshlerHoffman().generatedInterval(value: value),
                             order: 0)
        case .random:
            self = .random(value: value, current: 0)
            nextRandom()
        case .empty:
            self = .empty
        }
    }
}

public extension Parameter {
    /// Variable builder
    static func variable(_ value: Int, values: [Int]) -> Parameter {
        return Parameter.variable(value: value, values: values, order: 0)
    }

    /// Variable builder
    static func variable(_ value: Int, iterations: Int) -> Parameter {
        return Parameter.variable(value: value,
                                  values: FleshlerHoffman().generatedInterval(value: value, iterations: iterations),
                                  order: 0)
    }

    /// Random builder
    static func random(_ value: Int) -> Parameter {
        return Parameter.random(value: value, current: 0)
    }
}

extension Parameter: CustomStringConvertible {
    public var description: String {
        switch self {
        case .fixed:
            return "fixed"
        case .variable:
            return "variable"
        case .random:
            return "random"
        case .empty:
            return "empty"
        }
    }
}

public extension Parameter {
    func getValue() -> Int {
        switch self {
        case .fixed(let v):
            return v
        case let .variable(_, values: vs, order: o):
            return vs[o]
        case .random(_, let v):
            return v
        case .empty:
            return 0
        }
    }

    mutating func next() {
        switch self {
        case .variable:
            nextOrder()
        case .random:
            nextRandom()
        default:
            return
        }
    }

    func nextOrder() {
        switch self {
        case .variable(_, let values, var order):
            order = (order + 1) % values.count
        default:
            return
        }
    }

    mutating func nextRandom() {
        switch self {
        case .random(let v, _):
            self = Parameter.random(value: v,
                                    current: v > 0 ? Int.random(in: 1...v) : 0)
        default:
            return
        }
    }
}
