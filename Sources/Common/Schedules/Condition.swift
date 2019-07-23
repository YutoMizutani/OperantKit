//
//  Condition.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/22.
//

import RxSwift

public protocol Conditionable {
    var nextReinforcementCriterion: ResponseCompatible { get set }
    var nextAdditionalCriterion: ResponseCompatible { get set }
}

public extension ObservableType where Element: ResponseCompatible {
    func condition(_ predicate: @escaping (Element) throws -> Consequence) -> Observable<Consequence> {
        return asObservable()
            .map(predicate)
    }
}

public extension ObservableType {
    func condition(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
        return asObservable()
            .filter(predicate)
    }
}
