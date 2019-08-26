//
//  ReinforcementSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

public protocol ReinforcementSchedule: class {
    func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence>
}

public extension ReinforcementSchedule {
    func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return transform(source, isAutoUpdateReinforcementValue: true)
    }
}

public protocol ConcurrentReinforcementSchedule: class {
    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: [Observable<Response>]) -> Observable<Consequence>

    /// Combine results into single stream
    ///
    /// e.g. When the chamber has only one feeder
    ///
    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: Observable<Response>...) -> Observable<Consequence>

    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: [Observable<Response>]) -> [Observable<Consequence>]

    /// - Parameters:
    ///     - sources: Target responses
    func transform(_ sources: Observable<Response>...) -> [Observable<Consequence>]
}

public protocol ReinforcementStoreable: class {
    var lastReinforcementValue: Response { get set }

    func updateLastReinforcement(_ consequence: Consequence)
}

public typealias ResponseStoreableReinforcementSchedule = ReinforcementSchedule & ReinforcementStoreable
