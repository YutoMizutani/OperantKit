//
//  Discriminateable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Discriminative stimulus parameter requirements protocol
public protocol Discriminateable {
    /// Discriminative stimulus type
    associatedtype DiscriminativeStimulusType
    /// Discriminative stimulus
    var discriminativeStimulus: DiscriminativeStimulusType { get }
}

public extension Discriminateable {
    /// The short name of discriminative stimulus
    var sd: DiscriminativeStimulusType {
        return discriminativeStimulus
    }
}
