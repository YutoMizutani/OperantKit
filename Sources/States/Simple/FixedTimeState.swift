//
//  FixedTimeState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public struct FixedTimeState {
    public var elapsedTime: BehaviorRelay<Int>

    public init() {
        self.elapsedTime = BehaviorRelay<Int>(value: 0)
    }
}
