//
//  ScheduleParameterable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol ScheduleParameterable: class {
    var parameters: [Parameter] { get set }
}
