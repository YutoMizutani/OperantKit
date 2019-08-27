//
//  ContinuousReinforcement.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/28.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Continuous Reinforcement schedule
    ///
    /// - Important: Works faster than FR 1.
    /// - Complexity: O(1)
    func continuousReinforcement() -> Observable<Consequence> {
        return CRF().transform(asResponse())
    }
}

/// Continuous Reinforcement schedule
///
/// - Important: Works faster than FR 1.
public typealias CRF = ContinuousReinforcement

/// Continuous Reinforcement schedule
///
/// - Important: Works faster than FR 1.
public final class ContinuousReinforcement: ReinforcementSchedule, LastEventComparable {
    public var lastEventValue: Response = .zero

    public init() {}

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        let current: Response = response.asResponse() - lastEventValue
        let isReinforcement: Bool = current.numberOfResponses > 0
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
