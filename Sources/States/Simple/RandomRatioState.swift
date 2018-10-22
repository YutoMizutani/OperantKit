//
//  RandomRatioState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public struct RandomRatioState {
    public var numOfResponse: BehaviorRelay<Int>

    public init() {
        self.numOfResponse = BehaviorRelay<Int>(value: 0)
    }
}
