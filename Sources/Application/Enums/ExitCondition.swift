//
//  ExitCondition.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public enum ExitCondition {
    /// The experiment exit by reinforcement
    case reinforcement(Int)
    /// The experiment exit by time
    case time(Milliseconds)
}
