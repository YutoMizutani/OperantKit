//
//  FixedRatio.swift
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
        return FR(value).transform(asResponse())
    }
}

/// Fixed ratio schedule
///
/// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
///
/// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
///
/// - Parameter value: Reinforcement value
public typealias FR = FixedRatio

/// Fixed ratio schedule
///
/// IN A FIXED-RATIO SCHEDULE of reinforcement, every *n*th response produces a reinforcing stimulus.
///
/// Skinner, B. F.. Schedules of Reinforcement (B. F. Skinner reprint Series, edited by Julie S. Vargas Book 4) (Kindle Locations 1073-1074). B. F. Skinner Foundation. Kindle Edition.
///
/// - Parameter value: Reinforcement value
public final class FixedRatio: ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastEventValue
        let isReinforcement: Bool = current.numberOfResponses > 0 && current.numberOfResponses >= value
        if isReinforcement {
            return .reinforcement(response)
        } else {
            return .none(response)
        }
    }

    public func updateLastEvent(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            lastEventValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        var outcome: Observable<Consequence> = source.map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { [unowned self] in self.updateLastEvent($0) })
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
