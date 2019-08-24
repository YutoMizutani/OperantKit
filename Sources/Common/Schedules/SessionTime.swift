//
//  SessionTime.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2019/07/25.
//

import RxSwift

public extension ReinforcementSchedule {
    /// Reinforcement schedule with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ duration: TimeInterval) -> SessionTime {
        return SessionTime(schedule: self, sessionTime: duration)
    }
}

public extension ObservableType where Element == Consequence {
    /// Reinforcement schedule with session time
    ///
    /// - Complexity: O(1)
    func sessionTime(_ duration: TimeInterval) -> Observable<Consequence> {
        return takeWhile {
            $0.response.milliseconds <= duration.milliseconds
        }
    }
}

/// Reinforcement schedule with session time
///
/// - important: If the session time is met, it emits `Observable.completed`.
///
/// - Complexity: O(1)
public final class SessionTime: ReinforcementSchedule {
    public typealias ScheduleType = ReinforcementSchedule

    private let schedule: ScheduleType
    private let sessionTime: TimeInterval

    public init(schedule: ScheduleType,
                sessionTime: TimeInterval) {
        self.schedule = schedule
        self.sessionTime = sessionTime
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        return schedule.transform(source)
            .sessionTime(sessionTime)
            .share(replay: 1, scope: .whileConnected)
    }
}
