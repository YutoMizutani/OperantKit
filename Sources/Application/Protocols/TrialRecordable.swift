//
//  TrialRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol TrialRecordable {
    var startTime: Milliseconds { get set }
    var startEntities: ResponseEntity { get set }
}
