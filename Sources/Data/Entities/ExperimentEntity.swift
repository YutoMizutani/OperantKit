//
//  ExperimentEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/30.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public struct ExperimentEntity: Reinforceable {
    public let interReinforcementInterval: Milliseconds

    public init(interReinforcementInterval: Milliseconds) {
        self.interReinforcementInterval = interReinforcementInterval
    }
}
