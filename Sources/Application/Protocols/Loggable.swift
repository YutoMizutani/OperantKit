//
//  Loggable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Log parameter requrements protocol
public protocol Loggable {
    associatedtype Element
    typealias Log = (time: Milliseconds, element: Element)
    /// Stored logs
    var log: [Log] { get set }
}
