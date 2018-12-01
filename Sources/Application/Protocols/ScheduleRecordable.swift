//
//  ScheduleRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol ScheduleRecordable: class {
    var scheduleRecordEntities: [ScheduleRecordEntity] { get set }
}
