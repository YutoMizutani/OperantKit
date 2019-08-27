//
//  Concurrent.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/25.
//

import RxSwift

public extension Array where Element: Observable<ResponseCompatible> {
    /// Concurrent schedule
    ///
    /// - Complexity: O(1)
    func concurrent(_ schedules: [ReinforcementSchedule]) -> Observable<Consequence> {
        let sources: [Observable<Response>] = map { $0.map { $0.asResponse() } }
        return Concurrent(schedules).transform(sources)
    }

    /// Concurrent schedule
    ///
    /// - Complexity: O(1)
    func concurrent(_ schedules: [ReinforcementSchedule]) -> [Observable<Consequence>] {
        let sources: [Observable<Response>] = map { $0.map { $0.asResponse() } }
        return Concurrent(schedules).transform(sources)
    }
}

public extension Array where Element: ReinforcementSchedule {
    /// Concurrent schedule
    func concurrent() -> Concurrent {
        return Concurrent(self)
    }
}

/// Concurrent schedule
public typealias Conc = Concurrent

/// Concurrent schedule
public final class Concurrent: ConcurrentReinforcementSchedule {
    private let schedules: [ReinforcementSchedule]

    public init(_ schedules: [ReinforcementSchedule]) {
        self.schedules = schedules
    }

    /// - Parameters:
    ///     - schedules: Reinforcement schedules
    ///     - isSyncComplete: Complete all other streams when one completes
    public convenience init(_ schedules: ReinforcementSchedule...) {
        self.init(schedules)
    }

    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    public func transform(_ sources: [Observable<Response>]) -> Observable<Consequence> {
        return Observable.merge(schedules.enumerated().map { $0.element.transform(sources[$0.offset]) })
            .share(replay: 1, scope: .whileConnected)
    }

    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    public func transform(_ sources: Observable<Response>...) -> Observable<Consequence> {
        return transform(sources)
    }

    /// - Parameters:
    ///     - sources: Target responses
    public func transform(_ sources: [Observable<Response>]) -> [Observable<Consequence>] {
        let outcomes: [Observable<Consequence>] = schedules
            .enumerated()
            .map { $0.element.transform(sources[$0.offset]) }

        return outcomes.map { $0.share(replay: 1, scope: .whileConnected) }
    }

    /// - Parameters:
    ///     - sources: Target responses
    public func transform(_ sources: Observable<Response>...) -> [Observable<Consequence>] {
        return transform(sources)
    }
}
