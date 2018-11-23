//
//  ScheduleRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol ScheduleRecordable: class {
    var currentOrder: Int { get set }
    var currentValue: Int { get set }
}
