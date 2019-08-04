//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Extinction schedule
    ///
    /// - Complexity: O(1)
    func extinction() -> Observable<Consequence> {
        return map { .none($0) }
    }
}

/// Extinction schedule
public typealias EXT = Extinction

/// Extinction schedule
public struct Extinction: ReinforcementScheduleType {
    public init() {}

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return source
            .extinction()
    }
}
