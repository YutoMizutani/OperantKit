//
//  DiscreteTrialRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol DiscreteTrialRecordable {
    var trialState: TrialState { get set }
    var records: [TrialRecordable] { get set }
}
