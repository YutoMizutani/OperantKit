//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Fixed ratio schedule
    ///
    /// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
    ///
    /// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
    ///
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1) 
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

/// Fixed ratio schedule
///
/// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
///
/// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
///
/// - Parameter value: Reinforcement value
public struct FR<ResponseType: ResponseCompatible> {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func transform(_ source: Observable<ResponseType>) -> Observable<Consequence> {
        return source.asResponse()
            .fixedRatio(value)
    }
}
