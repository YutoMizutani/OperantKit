//
//  IntervalState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public protocol IntervalState {
    var responseTime: BehaviorRelay<Int> { get set }
}

extension FixedIntervalState: IntervalState {}
extension VariableIntervalState: IntervalState {}
