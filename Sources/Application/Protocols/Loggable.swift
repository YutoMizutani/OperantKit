//
//  Loggable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Log parameter requrements protocol
public protocol Loggable: class {
    typealias LogType = (id: Int, time: Milliseconds)
    /// Stored logs
    var logs: [LogType] { get set }
}
