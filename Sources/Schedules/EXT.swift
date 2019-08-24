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
        return EXT().transform(asResponse())
    }
}

/// Extinction schedule
public typealias EXT = Extinction

/// Extinction schedule
public final class Extinction: ReinforcementSchedule {
    public init() {}

    private func outcome(_ response: ResponseCompatible) -> Consequence {
        return .none(response)
    }

    public func transform(_ source: Observable<Response>, isAutoUpdateReinforcementValue: Bool) -> Observable<Consequence> {
        return source
            .map { self.outcome($0) }
            .share(replay: 1, scope: .whileConnected)
    }
}
