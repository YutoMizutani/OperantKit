//
//  Responsible.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Response parameter requirements protocol
public protocol Responsible {
    /// Number of responses
    var numOfResponses: Int { get set }
    /// Response time milliseconds
    var milliseconds: Milliseconds { get set }
}
