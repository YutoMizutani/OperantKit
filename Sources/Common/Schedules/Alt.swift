//
//  Alt.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

/// Alternative schedule
///
/// - Complexity: O(n)
public typealias Alt = Alternative

/// Alternative schedule
///
/// - Complexity: O(n)
public final class Alternative: ResponseStoreableReinforcementSchedule {
    public var lastReinforcementValue: Response = .zero {
        didSet {
            schedules.compactMap { $0 as? ReinforcementStoreable }
                .forEach { $0.lastReinforcementValue = self.lastReinforcementValue }
        }
    }

    private let schedules: [ReinforcementSchedule]

    public init(_ schedules: [ReinforcementSchedule]) {
        self.schedules = schedules
    }

    public convenience init(_ schedules: ReinforcementSchedule...) {
        self.init(schedules)
    }

    public func updateLastReinforcement(_ consequence: Consequence) -> Consequence {
        func update(_ response: ResponseCompatible) {
            schedules.compactMap { $0 as? ReinforcementStoreable }.forEach {
                _ = $0.updateLastReinforcement(consequence)
            }
            lastReinforcementValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }

        return consequence
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        let hotSource: Observable<Response> = source.share(replay: 1, scope: .whileConnected)
        var outcome: Observable<Consequence> = Observable
            .zip(schedules.map { $0.transform(hotSource, isAutoUpdateReinforcementValue: false) })
            .map { $0.merge() }

        if isAutoUpdateReinforcementValue {
            outcome = outcome.map { self.updateLastReinforcement($0) }
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
