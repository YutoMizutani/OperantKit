//
//  Reinforceable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Reinforcement parameter requirements protocol
public protocol Reinforceable {
    /// Inter reinforcement interval
    var interReinforcementInterval: Milliseconds { get }
}

public extension Reinforceable {
    /// The short name of inter reinforcement interval
    var iri: Milliseconds {
        return interReinforcementInterval
    }
}
