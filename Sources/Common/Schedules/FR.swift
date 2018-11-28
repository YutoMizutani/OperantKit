//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

public extension ResponseEntity {

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func fixedRatio(_ value: Int) -> Bool {
        return numOfResponses >= value
    }
}

public extension Single where E == ResponseEntity {

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func FR(_ value: Int) -> Single<Bool> {
        return map { $0.fixedRatio(value) }
    }

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func FR(_ value: Single<Int>) -> Single<Bool> {
        return flatMap { r in value.map { v in r.fixedRatio(v) } }
    }

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    func FR(value: @escaping () -> Single<Int>) -> Single<Bool> {
        return flatMap { r in value().map { v in r.fixedRatio(v) } }
    }
}
