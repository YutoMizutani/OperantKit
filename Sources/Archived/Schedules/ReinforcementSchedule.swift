//
//  ReinforcementSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

// MARK: - LastEventStoreable

public protocol LastEventComparable: class {
    var lastEventValue: Response { get set }

    func updateLastEvent(_ consequence: Consequence)
}

// MARK: - ReinforcementSchedule

public protocol ReinforcementSchedule: class {
    func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence>
}

public extension ReinforcementSchedule {
    func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return transform(source, isAutoUpdateReinforcementValue: true)
    }
}

// MARK: - ConcurrentReinforcementSchedule

public protocol ConcurrentReinforcementSchedule: class {
    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: [Observable<Response>], isSyncUpdateReinforcementValue: Bool) -> Observable<Consequence>

    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: Observable<Response>..., isSyncUpdateReinforcementValue: Bool) -> Observable<Consequence>

    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: [Observable<Response>]) -> [Observable<Consequence>]

    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: Observable<Response>...) -> [Observable<Consequence>]
}

public extension ConcurrentReinforcementSchedule {
    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: [Observable<Response>]) -> Observable<Consequence> {
        return transform(sources, isSyncUpdateReinforcementValue: false)
    }

    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: Observable<Response>...) -> Observable<Consequence> {
        return transform(sources, isSyncUpdateReinforcementValue: false)
    }
}
