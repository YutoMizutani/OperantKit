//
//  Chainable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Parameters of chain schedule requrements protocol
public protocol Chainable {
    /// Subschedules
    var subSchedules: [ScheduleUseCase] { get }
}
