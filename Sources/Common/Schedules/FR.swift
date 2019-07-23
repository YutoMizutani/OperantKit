//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func fixedRatio(_ value: Int) -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0 && current.numberOfResponses >= value
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
            }
    }
}

// TODO: Remove

extension ResponseEntity {

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .fixedRatio()
    func fixedRatio(_ value: Int) -> Bool {
        return numberOfResponses >= value
    }
}

public extension Single where Element == ResponseEntity {

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FR()
    func FR(_ value: @escaping @autoclosure () -> Int) -> Single<Bool> {
        return map { r in r.fixedRatio(value()) }
    }

    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .FR()
    func FR(_ value: Single<Int>) -> Single<Bool> {
        return flatMap { r in value.map { v in r.fixedRatio(v) } }
    }
}
