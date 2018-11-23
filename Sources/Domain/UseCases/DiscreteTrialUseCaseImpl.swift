//
//  DiscreteTrialUseCaseImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public struct DiscreteTrialUseCaseImpl: DiscreteTrialUseCase {
    public var repository: DiscreteTrialRepository

    public init(repository: DiscreteTrialRepository) {
        self.repository = repository
    }
}
