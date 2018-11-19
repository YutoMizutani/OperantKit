//
//  Discreteable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Discrete trial parameter requirements protocol
/// Discrete trial procedure <-> Continuous free-operant procedure
public protocol Discreteable {
    /// Inter trial interval
    var interTrialInterval: Milliseconds { get }
}

public extension Discreteable {
    /// The short name of inter trial interval
    var iti: Milliseconds {
        return interTrialInterval
    }
}
