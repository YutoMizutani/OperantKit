//
//  Loggable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Log parameter requrements protocol
public protocol Loggable {
    /// Stored responses
    var responses: [Responsible] { get set }
}
