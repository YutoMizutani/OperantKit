//
//  TimeUnitable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Time unit parameter requrements protocol
public protocol TimeUnitable {
    /// The full name of the time unit
    var longName: String { get }
    /// The short name of the time unit
    var shortName: String { get }

    /// Translated hours value
    func hours(_: Int) -> Hours?
    /// Translated minutes value
    func minutes(_: Int) -> Minutes?
    /// Translated seconds value
    func seconds(_: Int) -> Seconds?
    /// Translated milliseconds value
    func milliseconds(_: Int) -> Milliseconds
}
