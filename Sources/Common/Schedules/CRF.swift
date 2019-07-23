//
//  CRF.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/28.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
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

final public class CRF<ResponseType: ResponseCompatible> {
    private let source: Observable<ResponseType>
    public private(set) lazy var consequence: Observable<Consequence> = {
        return source.asResponse()
            .continuousReinforcement()
    }()

    init(source: Observable<ResponseType>) {
        self.source = source
    }
}

// TODO: Remove

public extension Single where Element == ResponseEntity {

    /// Continuous Reinforcement schedule
    ///
    /// - Important: Works faster than FR 1.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .CRF()
    func CRF() -> Single<Bool> {
        return map { r in r.fixedRatio(1) }
    }
}
