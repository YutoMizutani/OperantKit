//
//  CRF.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/28.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    /// Continuous Reinforcement schedule
    ///
    /// - Important: Works faster than FR 1.
    /// - Complexity: O(1)
    func continuousReinforcement() -> Observable<Consequence> {
        var lastReinforcementValue: Response = Response.zero
        return asObservable()
            .map {
                let current: Response = Response($0) - lastReinforcementValue
                let isReinforcement: Bool = current.numberOfResponses > 0
                if isReinforcement {
                    lastReinforcementValue = Response($0)
                    return .reinforcement($0)
                } else {
                    return .none($0)
                }
            }
    }
}

/// Continuous Reinforcement schedule
///
/// - Important: Works faster than FR 1.
public struct CRF<ResponseType: ResponseCompatible> {
    public init() {}

    public func transform(_ source: Observable<ResponseType>) -> Observable<Consequence> {
        return source.asResponse()
            .continuousReinforcement()
    }
}
