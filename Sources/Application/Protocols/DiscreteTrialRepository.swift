//
//  DiscreteTrialRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol DiscreteTrialRepository {
    var parameter: DiscreteTrialParameter { get }
    var recorder: DiscreteTrialRecordable { get set }
}
