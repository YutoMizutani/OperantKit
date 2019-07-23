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
        return asObservable()
            .map { .none($0) }
    }
}

/// Extinction schedule
public struct EXT<ResponseType: ResponseCompatible> {
    public init() {}

    public func transform(_ source: Observable<ResponseType>) -> Observable<Consequence> {
        return source.asResponse()
            .extinction()
    }
}
