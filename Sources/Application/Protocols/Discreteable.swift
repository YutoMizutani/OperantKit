//
//  Discreteable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import RxSwift

/// Discrete trial parameter requirements protocol
/// Discrete trial procedure <-> Continuous free-operant procedure
/// - Tag: Discreteable
public protocol Discreteable {
    func nextTrial() -> Single<Void>
    func updateState(_ state: TrialState) -> Single<Void>
}
