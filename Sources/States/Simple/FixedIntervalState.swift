//
//  FixedIntervalState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public struct FixedIntervalState {
    public var responseTime: BehaviorRelay<Int>

    public init() {
        self.responseTime = BehaviorRelay<Int>(value: 0)
    }
}
