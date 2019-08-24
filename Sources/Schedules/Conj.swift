//
//  Conj.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/25.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Conjunctive schedule
    ///
    /// - Complexity: O(n)
    func conjunctive(_ schedules: [ReinforcementSchedule]) -> Observable<Consequence> {
        return Conjunctive(schedules).transform(asResponse())
    }
}

public extension Array where Element: ReinforcementSchedule {
    /// Conjunctive schedule
    ///
    /// - Complexity: O(n)
    func conjunctive() -> Conjunctive {
        return Conjunctive(self)
    }
}

/// Conjunctive schedule
///
/// - Complexity: O(n)
public typealias Conj = Conjunctive

/// Conjunctive schedule
///
/// - Complexity: O(n)
public final class Conjunctive: ResponseStoreableReinforcementSchedule {
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

    private func outcome(_ consequences: [Consequence]) -> Consequence {
        let response = consequences.first!.response
        let isReinforcement: Bool = consequences.filter { !$0.isReinforcement }.isEmpty
        if isReinforcement {
            return .reinforcement(response)
        }
        return .none(response)
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
            .map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome.map { self.updateLastReinforcement($0) }
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
