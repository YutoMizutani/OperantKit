//
//  Consequence.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/22.
//

import Foundation

public enum Consequence {
    case none(ResponseCompatible)
    case reinforcement(ResponseCompatible)
}

public extension Consequence {
    var response: ResponseCompatible {
        switch self {
        case .none(let value):
            return value
        case .reinforcement(let value):
            return value
        }
    }

    var isReinforcement: Bool {
        if case .reinforcement = self {
            return true
        }
        return false
    }
}
