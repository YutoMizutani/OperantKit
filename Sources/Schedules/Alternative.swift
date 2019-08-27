//
//  Alternative.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Alternative schedule
    ///
    /// - Complexity: O(n)
    func alternative(_ schedules: [ReinforcementSchedule]) -> Observable<Consequence> {
        return Alternative(schedules).transform(asResponse())
    }
}

public extension Array where Element: ReinforcementSchedule {
    /// Alternative schedule
    ///
    /// - Complexity: O(n)
    func alternative() -> Alternative {
        return Alternative(self)
    }
}

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

    private func outcome(_ consequences: [Consequence]) -> Consequence {
        let response = consequences.first!.response
        let isReinforcement: Bool = !consequences.filter { $0.isReinforcement }.isEmpty
        if isReinforcement {
            return .reinforcement(response)
        }
        return .none(response)
    }

    public func updateLastReinforcement(_ consequence: Consequence) {
        func update(_ response: ResponseCompatible) {
            schedules.compactMap { $0 as? ReinforcementStoreable }.forEach {
                _ = $0.updateLastReinforcement(consequence)
            }
            lastReinforcementValue = response.asResponse()
        }

        if case .reinforcement = consequence {
            update(consequence.response)
        }
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        let hotSource: Observable<Response> = source.share(replay: 1, scope: .whileConnected)
        var outcome: Observable<Consequence> = Observable
            .zip(schedules.map { $0.transform(hotSource, isAutoUpdateReinforcementValue: false) })
            .map { self.outcome($0) }

        if isAutoUpdateReinforcementValue {
            outcome = outcome
                .do(onNext: { [unowned self] in self.updateLastReinforcement($0) })
        }

        return outcome.share(replay: 1, scope: .whileConnected)
    }
}
