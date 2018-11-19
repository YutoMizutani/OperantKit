//
//  Concurrentable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

/// Parameters of concurrent schedule requrements protocol
public protocol Concurrentable {
    /// Subschedules
    var subSchedules: [ScheduleUseCase] { get }
    /// Enable state if shared schedule
    /// To enable this flag when a common schedule applies to two or more types of operandam like the internal link in concurrent chained schedule.
    var isShared: Bool { get }
}
